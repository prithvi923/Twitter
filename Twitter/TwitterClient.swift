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
    
    static let sharedInstance = TwitterClient(baseURL: URL(string: "https://api.twitter.com")!, consumerKey: "Oxs5m9Odq8TDDuuN5Rs5cYCN3", consumerSecret: "hbjBljTnrFc70j5LA0w7q94h6uVt65VCYAPht3fuNysYCkDsoy")!
    
    var loginSuccess: (() -> ())?
    var loginFailure: ((Error) -> ()) = { (error: Error) in
        print("error: \(error.localizedDescription)")
    }
    
    let errorPrinter: ((URLSessionDataTask?, Error) -> ()) = { (task: URLSessionDataTask?, error: Error) in
        print("error: \(error.localizedDescription)")
    }
    
    var homeDelegate: HomeTimelineDelegate!
    var tweetEngageDelegate: TweetEngageDelegate!
    var loginDelegate: LoginDelegate!
    var userDelegate: HomeTimelineDelegate!
    var mentionsDelegate: HomeTimelineDelegate!
    
    func login() {
        TwitterClient.sharedInstance.deauthorize()
        TwitterClient.sharedInstance.fetchRequestToken(withPath: "oauth/request_token", method: "GET", callbackURL: URL(string: "twitterdemo://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential?) in
            let url = URL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken!.token!)")!
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }, failure: { (error: Error?) in
            self.loginFailure(error!)
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
                    self.loginDelegate.loggedIn()
                }, failure: { (error: Error) in
                    self.loginFailure(error)
                })
            },
            failure: { (error: Error?) in
                self.loginFailure(error!)
            })
    }
    
    func homeTimeline() {
        get("1.1/statuses/home_timeline.json",
            parameters: nil,
            progress: nil,
            success: { (task: URLSessionDataTask, response: Any?) in
                let tweetsDictionary = response as! [NSDictionary]
                self.homeDelegate.current(tweets: Tweet.tweets(tweetsDictionary))
            }, failure: errorPrinter)
    }
    
    func userTimeline(user: User) {
        get("1.1/statuses/user_timeline.json",
            parameters: ["screen_name": user.screenName!],
            progress: nil,
            success: { (task: URLSessionDataTask, response: Any?) in
                let tweetsDictionary = response as! [NSDictionary]
                self.userDelegate.current(tweets: Tweet.tweets(tweetsDictionary))
        }, failure: errorPrinter)
    }
    
    func mentionsTimeline() {
        get("1.1/statuses/mentions_timeline.json",
            parameters: nil,
            progress: nil,
            success: { (task: URLSessionDataTask, response: Any?) in
                let tweetsDictionary = response as! [NSDictionary]
                self.mentionsDelegate.current(tweets: Tweet.tweets(tweetsDictionary))
        }, failure: errorPrinter)
    }
    
    func newerTweets(than: String, completion: @escaping () -> ()) {
        get("1.1/statuses/home_timeline.json",
            parameters: ["since_id": than],
            progress: nil,
            success: { (task: URLSessionDataTask, response: Any?) in
                let tweetsDictionary = response as! [NSDictionary]
                self.homeDelegate.new(tweets: Tweet.tweets(tweetsDictionary))
                completion()
            }, failure: { (task: URLSessionDataTask?, error: Error) in
                completion()
            })
    }
    
    func olderTweets(than: String, completion: @escaping () -> ()) {
        let thanInt = Int(than)
        
        get("1.1/statuses/home_timeline.json",
            parameters: ["max_id": thanInt!-1],
            progress: nil,
            success: { (task: URLSessionDataTask, response: Any?) in
                let tweetsDictionary = response as! [NSDictionary]
                self.homeDelegate.old(tweets: Tweet.tweets(tweetsDictionary))
                completion()
            }, failure: { (task: URLSessionDataTask?, error: Error) in
                completion()
            })
    }
    
    func tweet(_ tweet: String, success: @escaping (Tweet) -> (), failure: @escaping (Error) -> ()) {
        post("1.1/statuses/update.json",
            parameters: ["status" : tweet],
            progress: nil,
            success: { (task: URLSessionDataTask, response: Any?) in
                let tweetDictionary = response as! NSDictionary
                success(Tweet(tweetDictionary))
            }, failure: { (task: URLSessionDataTask?, error: Error) in
                failure(error)
            })
    }
    
    /*
     TweetEngageDelegate
     */
    
    func favorite(with: String, onSuccess: @escaping () -> ()) {
        post("1.1/favorites/create.json",
             parameters: ["id" : with],
             progress: nil,
             success: { (task: URLSessionDataTask, response: Any?) in
                onSuccess()
        }, failure: errorPrinter)
    }
    
    func unfavorite(with: String, onSuccess: @escaping () -> ()) {
        post("1.1/favorites/destroy.json",
             parameters: ["id" : with],
             progress: nil,
             success: { (task: URLSessionDataTask, response: Any?) in
                onSuccess()
        }, failure: errorPrinter)
    }
    
    func retweet(with: String, onSuccess: @escaping (String) -> ()) {
        post("1.1/statuses/retweet/\(with).json",
             parameters: nil,
             progress: nil,
             success: { (task: URLSessionDataTask, response: Any?) in
                let tweetDictionary = response as! NSDictionary
                let tweet = Tweet(tweetDictionary)
                onSuccess(tweet.retweet_id!)
        }, failure: errorPrinter)
    }
    
    func unretweet(with: String, onSuccess: @escaping () -> ()) {
        post("1.1/statuses/unretweet/\(with).json",
            parameters: nil,
            progress: nil,
            success: { (task: URLSessionDataTask, response: Any?) in
                onSuccess()
        }, failure: errorPrinter)
    }
    
    func reply(to: Tweet, withStatus: String, success: @escaping () -> (), failure: @escaping (Error) -> ()) {
        post("1.1/statuses/update.json",
             parameters: ["in_reply_to_status_id" : to.id, "status" : withStatus],
             progress: nil,
             success: { (task: URLSessionDataTask, response: Any?) in
                success()
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            failure(error)
        })
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
