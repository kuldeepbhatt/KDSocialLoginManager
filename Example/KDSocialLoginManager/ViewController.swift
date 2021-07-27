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
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        /**
         Google client details :
         651532769644-qs1c47uev52rit58rgt9g1658iphks27.apps.googleusercontent.com
         651532769644-qs1c47uev52rit58rgt9g1658iphks27.apps.googleusercontent.com
         */
    }

}

// MARK: Actions
@available(iOS 11.0, *)
extension ViewController {
    @IBAction func fbLogin() {
        LoginHandler.shared.facebookLogin(with: ["email", "public_profile"],
                                     presentingViewController: self) { result, error in
            if error != nil {
                print("Error while Facebook login : \(String(describing: error?.localizedDescription))")
                return
            }
            print("Facebook Login successfull: \(String(describing: result))")
        }
    }
    
    @IBAction func googleLogin() {
        LoginHandler.shared.googleLogin(with: "651532769644-qs1c47uev52rit58rgt9g1658iphks27.apps.googleusercontent.com",
                                        presentingViewController: self) { user, error in
            if error != nil {
                print("Error while Google login : \(String(describing: error?.localizedDescription))")
                return
            }
            print("Google Login successfull: \(String(describing: user?.description))")
        }
    }
    
    @IBAction func linkedInLogin() {
    }
}

