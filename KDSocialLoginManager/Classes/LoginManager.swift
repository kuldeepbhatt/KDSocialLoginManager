//
//  LoginManager.swift
//  KDSocialLoginManager
//
//  Created by Kuldeep Bhatt on 2021/07/21.
//

import Foundation
import AppAuth

public class LoginManager: NSObject {
    public typealias AuthenticationCompletionHandler = ((String?, Error?) -> Void)
    private var currentAuthorizationFlow: OIDExternalUserAgentSession?
    private let presentingViewController: UIViewController
    private let redirectURI: URL?
    private let clientId: String

    public init(with clientId: String,
         viewController: UIViewController,
         redirectURI: URL?) {
        self.clientId = clientId
        self.presentingViewController = viewController
        self.redirectURI = redirectURI
    }

    public func oAuthLogin(with platform: Platform,
                      completionHandler: @escaping AuthenticationCompletionHandler) {
        switch platform {
            case .Facebook:
                AuthConfiguration.shared.discoverServiceConfiguration(for: .Facebook) { [weak self] serviceConfiguration, error in
                guard let serviceConfiguration = serviceConfiguration else { return }
                let strongSelf = self
                    self?.authenticate(from: strongSelf?.presentingViewController ?? UIViewController(),
                                   serviceConfiguration: serviceConfiguration,
                                   redirectURI: strongSelf?.redirectURI,
                                   clientId: strongSelf?.clientId,
                                   completionHandler: completionHandler)
            }
            case .LinkedIn:
                AuthConfiguration.shared.discoverServiceConfiguration(for: .LinkedIn) { [weak self] serviceConfiguration, error in
                    guard let serviceConfiguration = serviceConfiguration else { return }
                    let strongSelf = self
                    self?.authenticate(from: strongSelf?.presentingViewController ?? UIViewController(),
                                       serviceConfiguration: serviceConfiguration,
                                       redirectURI: strongSelf?.redirectURI,
                                       clientId: strongSelf?.clientId,
                                       completionHandler: completionHandler)
                }
            case .Google:
                AuthConfiguration.shared.discoverServiceConfiguration(for: .Google) { [weak self] serviceConfiguration, error in
                    guard let serviceConfiguration = serviceConfiguration else { return }
                    let strongSelf = self
                    strongSelf?.authenticate(from: strongSelf?.presentingViewController ?? UIViewController(),
                                       serviceConfiguration: serviceConfiguration,
                                       redirectURI: strongSelf?.redirectURI,
                                       clientId: strongSelf?.clientId,
                                       completionHandler: completionHandler)
                }
            default:break;
        }
    }
}

//MARK: Auth Requests
private extension LoginManager {
    /// Performs the full login authorization flow from the supplied viewcontroller. A valid service configuration is required, either through init
    /// or via discovery.
    ///
    /// - Parameters:
    ///   - viewController: The viewcontroller to perform full login from.
    ///   - serviceConfiguration: The service configuration to be used during authentication
    ///   - completionHandler: If authentication was successful, the access token will be returned. If not, an error will be returned.
    private func authenticate(from viewController: UIViewController,
                       serviceConfiguration: OIDServiceConfiguration?,
                       redirectURI: URL?,
                       clientId: String?,
                       completionHandler: AuthenticationCompletionHandler?) {
        guard let serviceConfiguration = serviceConfiguration,
              let clientId = clientId,
              let redirectURI = redirectURI,
              let completionHandler = completionHandler else { return }
        
        let request = OIDAuthorizationRequest(configuration: serviceConfiguration,
                                              clientId: clientId,
                                              scopes: [OIDScopeOpenID, OIDScopeProfile],
                                              redirectURL: redirectURI,
                                              responseType: OIDResponseTypeCode,
                                              additionalParameters: nil)
        
        currentAuthorizationFlow = OIDAuthState.authState(byPresenting: request,
                                                          presenting: self.presentingViewController,
                                                          callback: { [weak self] (state, error) in
                                                            completionHandler(state?.lastTokenResponse?.accessToken, error)
                                                          })
    }

    public func resumeExternalUserAgentFlow(with url: URL) {
        guard let flow = currentAuthorizationFlow else {
            return
        }
        
        if flow.resumeExternalUserAgentFlow(with: url) {
            currentAuthorizationFlow = nil;
        }
    }
}
