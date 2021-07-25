//
//  ViewController.swift
//  KDSocialLoginManager
//
//  Created by kuldeepbhatt on 07/21/2021.
//  Copyright (c) 2021 kuldeepbhatt. All rights reserved.
//

import UIKit
import KDSocialLoginManager
import SafariServices

@available(iOS 11.0, *)
class ViewController: UIViewController {

    var authSession: SFAuthenticationSession?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

// MARK: Actions
@available(iOS 11.0, *)
extension ViewController {
    @IBAction func fbLogin() {
        var loginManager = LoginManager(with: "183170133853832",
                                        viewController: self,
                                 redirectURI: URL(string: "https://www.google.com"))
        loginManager.oAuthLogin(with: .Facebook) { token, error in
            if error != nil {
                print("Error occured: ", error?.localizedDescription ?? "")
                return
            }
            print("FB Login successfull")
        }
    }
    
    @IBAction func googleLogin() {
        var loginManager = LoginManager(with: "183170133853832",
                                        viewController: self,
                                        redirectURI: URL(string: "https://www.google.com"))
        loginManager.oAuthLogin(with: .Google) { token, error in
            if error != nil {
                print("Error occured: ", error?.localizedDescription ?? "")
                return
            }
            print("FB Login successfull")
        }
    }
    
    @IBAction func linkedInLogin() {
    }
}

