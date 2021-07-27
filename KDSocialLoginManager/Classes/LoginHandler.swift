//
//  LoginHandler.swift
//  KDSocialLoginHandler
//
//  Created by Kuldeep Bhatt on 2021/07/21.
//

import Foundation
import AppAuth
import FBSDKLoginKit
import GoogleSignIn

public class LoginHandler: NSObject {

    public static let shared = LoginHandler()

    public typealias AuthenticationCompletionHandler = ((String?, Error?) -> Void)
    private var currentAuthorizationFlow: OIDExternalUserAgentSession?
    public func loginWithOAuth(for platform: Platform,
                               clientID: String,
                               redirectURI: URL?,
                               with presentingViewController: UIViewController,
                               completionHandler: @escaping AuthenticationCompletionHandler) {
        switch platform {
            case .Facebook:
                AuthConfiguration.shared.discoverServiceConfiguration(for: .Facebook) { [weak self] serviceConfiguration, error in
                    guard let serviceConfiguration = serviceConfiguration else { return }
                    self?.authenticate(from: presentingViewController,
                                       serviceConfiguration: serviceConfiguration,
                                       redirectURI: redirectURI,
                                       clientId: clientID,
                                       completionHandler: completionHandler)
                }
            case .LinkedIn:
                AuthConfiguration.shared.discoverServiceConfiguration(for: .LinkedIn) { [weak self] serviceConfiguration, error in
                    guard let serviceConfiguration = serviceConfiguration else { return }
                    self?.authenticate(from: presentingViewController,
                                       serviceConfiguration: serviceConfiguration,
                                       redirectURI: redirectURI,
                                       clientId: clientID,
                                       completionHandler: completionHandler)
                }
            case .Google:
                AuthConfiguration.shared.discoverServiceConfiguration(for: .Google) { [weak self] serviceConfiguration, error in
                    guard let serviceConfiguration = serviceConfiguration else { return }
                    self?.authenticate(from: presentingViewController,
                                             serviceConfiguration: serviceConfiguration,
                                             redirectURI: redirectURI,
                                             clientId: clientID,
                                             completionHandler: completionHandler)
                }
            default:break;
        }
    }
}

// MARK: Login with SDKs
public extension LoginHandler {

    func facebookLogin(with readPerms: [String],
                              presentingViewController: UIViewController,
                              completionHandler: @escaping  AuthenticationCompletionHandler) {
        LoginManager().logIn(permissions: readPerms, from: presentingViewController) { loginResult, error in
            let tokenString = loginResult?.token?.tokenString
            tokenString != nil ? completionHandler(tokenString, nil) : completionHandler(nil, error)
        }
    }

    func googleLogin(with clientID: String,
                            presentingViewController: UIViewController,
                            completionHandler: @escaping  GIDSignInCallback) {
        let signInConfig = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.signIn(
            with: signInConfig,
            presenting: presentingViewController
        ) { user, error in
            guard error == nil else { return }
            guard let user = user else { return }
            completionHandler(user, error)
        }
    }

    func logout(from platform: Platform) {
        switch platform {
        case .Facebook: LoginManager().logOut()
        case .Google: GIDSignIn.sharedInstance.signOut()
        case .LinkedIn: break
        default: break
        }
    }
}


//MARK: Auth Requests
private extension LoginHandler {
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
                                                          presenting: viewController,
                                                          callback: { [weak self] (state, error) in
                                                            completionHandler(state?.lastTokenResponse?.accessToken, error)
                                                          })
    }

    func resumeExternalUserAgentFlow(with url: URL) {
        guard let flow = currentAuthorizationFlow else {
            return
        }
        
        if flow.resumeExternalUserAgentFlow(with: url) {
            currentAuthorizationFlow = nil;
        }
    }
}
