import Foundation

final class ImagesListService {
    private(set) var photos: [Photo] = []
    private var lastLoadedPage: Int?
    private var task: URLSessionTask?
    private let decoder = JSONDecoder()
    private let storage = OAuth2TokenStorage()
    
    static let shared = ImagesListService()
    static let didChangeNotification = Notification.Name("ImagesListServiceDidChange")
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
    private func makeRequest(accessToken: String) -> URLRequest {
        let nextPage = (lastLoadedPage ?? 0) + 1
        let baseURL = URL(string: "https://api.unsplash.com")
        let url = URL(
            string: "/photos?page=\(nextPage)",
            relativeTo: baseURL
        )!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        return request
     }
    
    func fetchPhotosNextPage() {
        task?.cancel()
        
        guard let token = storage.token else {
            return
        }
        
        print("token: \(token)")
        
        let url = makeRequest(accessToken: token)
        
        let task = URLSession.shared.objectTask(for: url) { [weak self] (result: Result<[PhotoResult], Error>) in
            switch result {
            case .success(let items):
                DispatchQueue.main.async {
                    let newPhotos = items.map { i in
                        return Photo(
                            id: i.id,
                            size: CGSize(width: i.width, height: i.height),
                            createdAt: self?.dateFormatter.date(from: i.createdAt ?? ""),
                            welcomeDescription: i.description,
                            thumbImageURL: i.urls.thumb,
                            largeImageURL: i.urls.full,
                            isLiked: i.likedByUser)
                    }
                    
                    self?.photos.append(contentsOf: newPhotos)
                    
                    NotificationCenter.default.post(
                        name: ImagesListService.didChangeNotification,
                        object: self)
                }
            case .failure(let error):
                print("[fetchPhotosNextPage]: \(error.localizedDescription)")
                return
            }
            
            self?.task = nil
        }
        
        self.task = task
        task.resume()
    }
}
