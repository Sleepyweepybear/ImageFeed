import Foundation
enum Constants {
    static let accessKey = "7ARna4q67MDZ3TK9yDEPvAhGQVJlzaV26Z0LitxcG9w"
    static let secretKey = "JyNB9NC9QB9rcsUH6ZQSp9-qTs4usuTM2dxkrKsQTag"
    static let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
    static let accessScope = "public+read_user+write_likes"
    static private var defaultBaseURLGet: URL {
        guard let url = URL(string: "https://api.unsplash.com") else {
            preconditionFailure("Invalid URL")
        }
        return url
    }
  }
