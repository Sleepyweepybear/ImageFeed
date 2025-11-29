import Foundation

final class OAuth2Service {
    static let shared = OAuth2Service()
    private init() { }

    func fetchOAuthToken(_ code: String, completion: @escaping (Result<String, Error>) -> Void) {
        guard let request = makeOAuthTokenRequest(code: code) else {
            print("[OAuth2Service] Не получилось создать запрос для получения токена")
            completion(.failure(NSError(domain: "Не получилось создать запрос", code: 0)))
            return
        }

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("[OAuth2Service] Ошибка сети: \(error)")
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                print("[OAuth2Service] Некорректный HTTP ответ")
                DispatchQueue.main.async {
                    completion(.failure(NSError(domain: "Некорректный HTTP ответ", code: 0)))
                }
                return
            }

            guard let data = data else {
                print("[OAuth2Service] Нет данных в ответе")
                DispatchQueue.main.async {
                    completion(.failure(NSError(domain: "Нет данных", code: 0)))
                }
                return
            }

            guard (200...299).contains(httpResponse.statusCode) else {
                print("[OAuth2Service] Ответ Unsplash со статус-кодом \(httpResponse.statusCode)")
                if let bodyString = String(data: data, encoding: .utf8) {
                    print("[OAuth2Service] Тело ответа: \(bodyString)")
                }
                DispatchQueue.main.async {
                    completion(.failure(NSError(domain: "Некорректный статус-код", code: httpResponse.statusCode)))
                }
                return
            }

            do {
                let decoder = JSONDecoder()
                let responseBody = try decoder.decode(OAuthTokenResponseBody.self, from: data)
                let token = responseBody.accessToken
                print("[OAuth2Service] Токен получен: \(token)")

                OAuth2TokenStorage.shared.token = token

                DispatchQueue.main.async {
                    completion(.success(token))
                }
            } catch {
                print("[OAuth2Service] Ошибка декодинга OAuthTokenResponseBody: \(error)")
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }

        task.resume()
    }
    
    private func makeOAuthTokenRequest(code: String) -> URLRequest? {
        guard var urlComponents = URLComponents(string: "https://unsplash.com/oauth/token") else {
            print("[OAuth2Service] Не удалось создать URLComponents для токен-запроса")
            return nil
        }

        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: Constants.accessKey),
            URLQueryItem(name: "client_secret", value: Constants.secretKey),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "grant_type", value: "authorization_code")
        ]

        guard let authTokenUrl = urlComponents.url else {
            print("[OAuth2Service] Не удалось получить URL из URLComponents: \(urlComponents)")
            return nil
        }

        var request = URLRequest(url: authTokenUrl)
        request.httpMethod = "POST"
        return request
    }
