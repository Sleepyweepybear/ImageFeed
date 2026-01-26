import Foundation
import SwiftKeychainWrapper

final class OAuth2TokenStorage {
    private let tokenKey = "access_token"
    
    var token: String? {
        get {
            let token = KeychainWrapper.standard.string(forKey: tokenKey)
            return token
        }
        set {
            guard let newValue else { return }
            KeychainWrapper.standard.set(newValue, forKey: tokenKey)
        }
    }
}
