//
//  LoginViewController+LoginDelegate.swift
//  Twitter
//
//  Created by Prithvi Prabahar on 10/7/17.
//  Copyright © 2017 Prithvi Prabahar. All rights reserved.
//

import Foundation

extension LoginViewController: LoginDelegate {
    func loggedIn() {
        self.performSegue(withIdentifier: "loginSegue", sender: nil)
    }
}
