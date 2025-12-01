import Foundation

enum AuthServiceError: Error {
    case invalidRequest
}

final class OAuth2Service {
    static let shared = OAuth2Service()
    
    private let dataStorage = OAuth2TokenStorage.shared
    private let urlSession = URLSession.shared
    
    private var task: URLSessionTask?
    private var lastCode: String?
    
    private(set) var authToken: String? {
        get {
            return dataStorage.token
        }
        set {
            dataStorage.token = newValue
        }
    }
    
    private init() { }
    
    // MARK: - Token
    
    func fetchOAuthToken(_ code: String, completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        
        // Проверка на одинаковые запросы
        if task != nil {
            if lastCode != code {
                task?.cancel()
            } else {
                print("[fetchOAuthToken]: Ошибка - повторный запрос с тем же кодом")
                completion(.failure(AuthServiceError.invalidRequest))
                return
            }
        } else {
            if lastCode == code {
                print("[fetchOAuthToken]: Ошибка - повторный запрос с тем же кодом")
                completion(.failure(AuthServiceError.invalidRequest))
                return
            }
        }
        
        // Сохраняем последний использованный код
        lastCode = code
        
        // Формируем запрос
        guard let request = makeOAuthTokenRequest(code: code) else {
            print("[fetchOAuthToken]: Ошибка - неверный URL запроса")
            completion(.failure(AuthServiceError.invalidRequest))
            return
        }
        
        // Выполняем запрос
        let task = urlSession.dataTask(with: request) { [weak self] data, response, error in
            DispatchQueue.main.async {
                self?.task = nil
                self?.lastCode = nil
                
                if let error = error {
                    print("[fetchOAuthToken]: Ошибка сети: \(error.localizedDescription)")
                    completion(.failure(error))
                    return
                }
                
                guard let data = data else {
                    print("[fetchOAuthToken]: Нет данных в ответе")
                    completion(.failure(AuthServiceError.invalidRequest))
                    return
                }
                
                // Обрабатываем ответ
                do {
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .secondsSince1970
                    let responseBody = try decoder.decode(OAuthTokenResponseBody.self, from: data)
                    let token = responseBody.accessToken
                    self?.authToken = token
                    completion(.success(token))
                } catch {
                    print("[fetchOAuthToken]: Ошибка декодирования: \(error)")
                    completion(.failure(error))
                }
            }
        }
        self.task = task
        task.resume()
    }
    
    private func makeOAuthTokenRequest(code: String) -> URLRequest? {
        guard var urlComponents = URLComponents(string: "https://unsplash.com/oauth/token") else {
            print("[OAuth2Service] Не удалось создать URL")
            return nil
        }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: Constants.accessKey),
            URLQueryItem(name: "client_secret", value: Constants.secretKey),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "grant_type", value: "authorization_code"),
        ]
        
        guard let authTokenUrl = urlComponents.url else {
            return nil
        }
        
        var request = URLRequest(url: authTokenUrl)
        request.httpMethod = "POST"
        return request
    }
}
