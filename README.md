# KDSocialLoginManager

[![CI Status](https://img.shields.io/travis/kuldeepbhatt/KDSocialLoginManager.svg?style=flat)](https://travis-ci.org/kuldeepbhatt/KDSocialLoginManager)
[![Version](https://img.shields.io/cocoapods/v/KDSocialLoginManager.svg?style=flat)](https://cocoapods.org/pods/KDSocialLoginManager)
[![License](https://img.shields.io/cocoapods/l/KDSocialLoginManager.svg?style=flat)](https://cocoapods.org/pods/KDSocialLoginManager)
[![Platform](https://img.shields.io/cocoapods/p/KDSocialLoginManager.svg?style=flat)](https://cocoapods.org/pods/KDSocialLoginManager)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Installation

KDSocialLoginManager is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'KDSocialLoginManager'
```

## Requirements
Steps to successfully integrate the ```KDSocialLoginManager``` in your application
* Add the URL Types for all the platforms you want to support in your application (e.g. Facebook, LinkedIn, Google) <img width="1139" alt="Screenshot 2021-07-27 at 23 01 12" src="https://user-images.githubusercontent.com/9594697/127227668-76a48a88-d3b1-418f-8dcf-890d9c929ad1.png">



* Add the import statement in your controller from where you want to present the social login flow
```ruby
import KDSocialLoginManager
```


* Finally, add below code based on the platform (Facebook, Google, LinkedIn)


### Facebook
```ruby
LoginHandler.shared.facebookLogin(with: ["email", "public_profile"],
                                              presentingViewController: self) { result, error in
                if error != nil {
                    print("Error while Facebook login : \(String(describing: error?.localizedDescription))")
                    return
                }
                self.facebookLoginBtn.setTitle("Logout from Facebook", for: .normal)
                print("Facebook Login successfull: \(String(describing: result))")
            }
            
```     


### Google

```ruby
LoginHandler.shared.googleLogin(with: "*********************************************.apps.googleusercontent.com",
                                            presentingViewController: self) { user, error in
                if error != nil {
                    print("Error while Google login : \(String(describing: error?.localizedDescription))")
                    return
                }
                self.googleLoginBtn.setTitle("Logout from Google", for: .normal)
                print("Google Login successfull: \(String(describing: user?.description))")
            }
            
 ```
 
 
 ### LinkedIn : Since linked only supports OAuth 2.0 

```ruby
LoginHandler.shared.loginWithOAuth(for: .LinkedIn,
                                           clientID: "***************",
                                           redirectURI: URL(string: "linkedin://profile/******"),
                                           with: self) { token, error in
            (error == nil) ? (self.linkedInLoginBtn.setTitle("Logout", for: .normal)) : (print("Error while Linked In Login: \(String(describing: error?.localizedDescription))"))
        }

```

 ### Google with OAuth 2.0 

```ruby
LoginHandler.shared.loginWithOAuth(for: .Google,
                                           clientID: "*********************************************.apps.googleusercontent.com",
                                           redirectURI: URL(string: "com.googleusercontent.apps.*********************************************"),
                                           with: self) { token, error in
            (error == nil) ? (self.googleLoginBtn.setTitle("Logout", for: .normal)) : (print("Error while Google Login: \(String(describing: error?.localizedDescription))"))
            
```

## Author

kuldeepbhatt, bhatt.it2010@gmail.com

## License

KDSocialLoginManager is available under the MIT license. See the LICENSE file for more info.
