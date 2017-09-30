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
    
    init(_ tweet: NSDictionary) {
        text = tweet["text"] as? String
    }
    
    class func tweets(_ tweetsDictionary: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()
        for tweet in tweetsDictionary {
            tweets.append(Tweet(tweet))
        }
        return tweets
    }
}
