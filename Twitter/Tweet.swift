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
    var date: Date?
    var profileURL: URL?
    var username: String?
    var screenName: String?
    var id: String?
    var favoriteCount: Int?
    var retweetCount: Int?
    var favorited: Bool?
    var retweeted: Bool?
    var retweet_id: String?
    var tweetEngageDelegate: TweetEngageDelegate!
    
    static var dateFormatter: DateFormatter {
        get {
            let dateFormatter = DateFormatter()
            // "Tue Aug 28 21:16:23 +0000 2012"
            dateFormatter.dateFormat = "EEE MMM d HH:mm:ss Z yyyy"
            return dateFormatter
        }
    }
    
    static var detailDateFormatter: DateFormatter {
        get {
            let dateFormatter = DateFormatter()
            // "9/30/17, 6:02 PM"
            dateFormatter.dateFormat = "M/d/yy, h:mm a"
            dateFormatter.amSymbol = "AM"
            dateFormatter.pmSymbol = "PM"
            return dateFormatter
        }
    }
    
    init(_ tweet: NSDictionary) {
        super.init()
        text = tweet["text"] as? String
        let dateString = tweet["created_at"] as? String
        date = getDate(from: dateString!)
        id = tweet["id_str"] as? String
        favoriteCount = tweet["favorite_count"] as? Int
        retweetCount = tweet["retweet_count"] as? Int
        favorited = tweet["favorited"] as? Bool
        retweeted = tweet["retweeted"] as? Bool
        if let user = tweet["user"] as? NSDictionary {
            profileURL = URL(string: (user["profile_image_url_https"] as? String)!)
            username = user["name"] as? String
            screenName = user["screen_name"] as? String
        }
        
        if let retweet = tweet["retweeted_status"] as? NSDictionary {
            retweet_id = retweet["id_str"] as? String
        }
    }
    
    func retweetToggle() {
        if (retweeted!) {
            TwitterClient.sharedInstance.unretweet(with: retweet_id!, onSuccess: {
                self.retweetCount! -= 1
                self.retweet_id = nil
                self.retweeted = false
                self.tweetEngageDelegate.updateEngagement()
            })
        } else {
            TwitterClient.sharedInstance.retweet(with: id!, onSuccess: { (retweet_id) in
                self.retweetCount! += 1
                self.retweet_id = retweet_id
                self.retweeted = true
                self.tweetEngageDelegate.updateEngagement()
            })
        }
    }
    
    class func tweets(_ tweetsDictionary: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()
        for tweet in tweetsDictionary {
            tweets.append(Tweet(tweet))
        }
        return tweets
    }
    
    // https://gist.github.com/minorbug/468790060810e0d29545
    func timeAgoSinceDate() -> String {
        let calendar = NSCalendar.current
        let unitFlags: Set<Calendar.Component> = [.minute, .hour, .day, .weekOfYear, .month, .year, .second]
        let now = Date()
        let components = calendar.dateComponents(unitFlags, from: date!,  to: now)
        
        if (components.year! >= 1) {
            return "\(components.year!)yr"
        } else if (components.month! >= 1) {
            return "\(components.month!)mo"
        } else if (components.weekOfYear! >= 1) {
            return "\(components.weekOfYear!)w"
        } else if (components.day! >= 1) {
            return "\(components.day!)d"
        } else if (components.hour! >= 1) {
            return "\(components.hour!)h"
        } else if (components.minute! >= 1){
            return "\(components.minute!)m"
        } else if (components.second! >= 3) {
            return "\(components.second!)s"
        } else {
            return "Just now"
        }
    }
    
    func detailTime() -> String {
        return Tweet.detailDateFormatter.string(from: date!)
    }
    
    private func getDate(from: String) -> Date {
        return Tweet.dateFormatter.date(from: from)!
    }
}

protocol TweetEngageDelegate {
    func updateEngagement()
    func favorite()
    func unfavorite()
}
