//
//  LoginViewController.swift
//  Twitter
//
//  Created by Prithvi Prabahar on 9/28/17.
//  Copyright © 2017 Prithvi Prabahar. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class LoginViewController: UIViewController, LoginDelegate {
    
    private let client = TwitterClient.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()

        client.loginDelegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func loginPressed(_ sender: Any) {
        client.login()
    }
    
    func loggedIn() {
        self.performSegue(withIdentifier: "loginSegue", sender: nil)
    }

}
