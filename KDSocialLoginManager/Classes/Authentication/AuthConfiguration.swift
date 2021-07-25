import Foundation
import AppAuth

public protocol ContentConvertible {
    func url(for urlString: String) -> URL?
}

/// Convenience enumeration that handles configuration required for performing authentication
/// on different social platforms.
class AuthConfiguration {
    static let shared = AuthConfiguration()
    /// the default scopes
    static let defaultScopes: [String] = ["openid", "offline_access", "sso"]
    
    
    /// The requested scopes for authentication.
    /// Any additional scopes have to be configured in the plist of the consuming appplication by adding a CustomScopes section of type array in within the dictionary
    /// The default scopes will be added and the custom scopes will be appended to the scopes that are returned
    static var allScopes: [String] {
        var scopeArray = defaultScopes
        return scopeArray
    }

    /// This function returns the relevant URL for the authentication issuer
    /// This `URL` is used for service configuration discovery and authentication.
    ///
    /// - Parameter issuer: The string issuer string value
    /// - Returns: The platform specific URL.
    private func issuer(for issuer: Platform) -> URL? {
        switch issuer {
        case .Facebook: return self.url(for: OAuthUrls.oAuthFacebookEndpoint)
        case .Google: return self.url(for: OAuthUrls.oAuthGoogleEndpoint)
        case .LinkedIn:  return self.url(for: OAuthUrls.oAuthLinkedInEndpoint)
        default: return nil
        }
    }

    /// Discovers the issuer's OID service configuration. This is performed before authentication and token
    /// refresh requests.
    ///
    /// - Parameter completion: If a valid configuration was discovered, it will be returned, otherwise an error.
    func discoverServiceConfiguration(for platform: Platform,
                                              completion: @escaping (OIDServiceConfiguration?, Error?) -> Void) {
        //guard let url = issuer(for: platform) else { return }
        var authorizationEndpoint: URL?,
            tokenEndpoint: URL?
        switch platform {
            case .Facebook:
            authorizationEndpoint = self.url(for: OAuthUrls.oAuthFacebookEndpoint)
            tokenEndpoint = self.url(for: OAuthUrls.oAuthFacebookEndpoint)
            case .Google:
            authorizationEndpoint = self.url(for: OAuthUrls.oAuthGoogleEndpoint)
            tokenEndpoint = self.url(for: OAuthUrls.oAuthGoogleTokenEndpoint)
            case .LinkedIn:
            authorizationEndpoint = self.url(for: OAuthUrls.oAuthLinkedInEndpoint)
            tokenEndpoint = self.url(for: OAuthUrls.oAuthLinkedInEndpoint)
            default:break
        }
        guard let authEndpoint = authorizationEndpoint,
              let tokEndpoint = tokenEndpoint else { return }

        let serviceConfiguration = OIDServiceConfiguration(authorizationEndpoint: authEndpoint,
                                                           tokenEndpoint: tokEndpoint)
        if serviceConfiguration != nil {
            completion(serviceConfiguration, nil)
        }
    }
}

extension AuthConfiguration: ContentConvertible {
   func url(for urlString: String) -> URL? {
    return URL(string: urlString)
   }
}
