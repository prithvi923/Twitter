//
//  TwitterClient.swift
//  Twitter
//
//  Created by Prithvi Prabahar on 9/28/17.
//  Copyright © 2017 Prithvi Prabahar. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class TwitterClient: BDBOAuth1SessionManager {
    
    static let sharedInstance = TwitterClient(baseURL: URL(string: "https://api.twitter.com")!, consumerKey: "Oxs5m9Odq8TDDuuN5Rs5cYCN3", consumerSecret: "hbjBljTnrFc70j5LA0w7q94h6uVt65VCYAPht3fuNysYCkDsoy")
    
    var loginSuccess: (() -> ())?
    var loginFailure: ((Error) -> ())?
    
    func login(success: @escaping () -> Void, failure: @escaping (Error) -> ()) {
        loginSuccess = success
        loginFailure = failure
        
        TwitterClient.sharedInstance?.deauthorize()
        TwitterClient.sharedInstance?.fetchRequestToken(withPath: "oauth/request_token", method: "GET", callbackURL: URL(string: "twitterdemo://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential?) in
            let url = URL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken!.token!)")!
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }, failure: { (error: Error?) in
            self.loginFailure?(error!)
        })
    }
    
    func logout() {
        User.current = nil
        deauthorize()
        
        NotificationCenter.default.post(name: User.userDidLogoutNotification, object: nil)
    }
    
    func handleOpenURL(_ url: URL) {
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        
        fetchAccessToken(
            withPath: "oauth/access_token",
            method: "POST",
            requestToken: requestToken,
            success: { (access_token: BDBOAuth1Credential?) in
                self.verifyCredentials(success: { (user: User) in
                    User.current = user
                    self.loginSuccess?()
                }, failure: { (error: Error) in
                    self.loginFailure?(error)
                })
            },
            failure: { (error: Error?) in
                self.loginFailure?(error!)
            })
    }
    
    func homeTimeline() {
        
    }
    
    func verifyCredentials(success: @escaping (User) -> (), failure: @escaping (Error) -> ()) {
        get("1.1/account/verify_credentials.json",
            parameters: nil,
            progress: nil,
            success: { (task: URLSessionDataTask, response: Any?) in
                let userDictionary = response as! NSDictionary
                let user = User(userDictionary)
                success(user)
            }, failure: { (task: URLSessionDataTask?, error: Error) in
                failure(error)
            })
    }
}
