import Foundation
import AppAuth
import os.log
import LocalAuthentication
import SafariServices

@objc public enum AuthType: Int {
    case none = 0
    case passcode = 1
    case touchID = 2
    case faceID = 3
}

internal extension LAContext {
    
    var keychainAuthenticationPolicy: AuthenticationPolicy {
        switch deviceAuthenticationType {
        case .touchID,
             .faceID:
            return .touchIDCurrentSet
        case .passcode,
             .none:
            return .userPresence
        }
    }
}

@objc public extension LAContext {
    
    var devicePasscodeEnabled: Bool {
        return canEvaluatePolicy(.deviceOwnerAuthentication, error: nil)
    }
    
    @objc public var deviceAuthenticationType: AuthType {
        let fallback: AuthType = devicePasscodeEnabled ? .passcode : .none
        
        var error: NSError?
        if canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            if #available(iOS 11.0, *) {
                switch self.biometryType {
                case .touchID:
                    return .touchID
                case .faceID:
                    return .faceID
                default:
                    return fallback
                }
            } else if canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil) {
                return .touchID
            }
        }
        return fallback
    }
}


