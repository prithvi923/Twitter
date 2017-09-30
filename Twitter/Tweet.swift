//
//  Tweet.swift
//  Twitter
//
//  Created by Prithvi Prabahar on 9/28/17.
//  Copyright © 2017 Prithvi Prabahar. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    
    var text: String?
    var timestamp: String?
    var profileURL: URL?
    var username: String?
    var screenName: String?
    
    init(_ tweet: NSDictionary) {
        text = tweet["text"] as? String
        timestamp = tweet["created_at"] as? String
        if let user = tweet["user"] as? NSDictionary {
            profileURL = URL(string: (user["profile_image_url_https"] as? String)!)
            username = user["name"] as? String
            screenName = user["screen_name"] as? String
        }
    }
    
    class func tweets(_ tweetsDictionary: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()
        for tweet in tweetsDictionary {
            tweets.append(Tweet(tweet))
        }
        return tweets
    }
}
