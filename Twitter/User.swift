//
//  User.swift
//  Twitter
//
//  Created by Prithvi Prabahar on 9/28/17.
//  Copyright © 2017 Prithvi Prabahar. All rights reserved.
//

import UIKit

class User: NSObject {
    
    var name: String?
    var screenName: String?
    var profileURL: URL?
    var backgroundURL: URL?
    var tagline: String?
    var followerCount: Int?
    var followingCount: Int?
    var tweetCount: Int?
    
    var dictionary: NSDictionary?
    
    init(_ user: NSDictionary) {
        name = user["name"] as? String
        screenName = user["screen_name"] as? String
        if let profile_url = user["profile_image_url_https"] {
            profileURL = URL(string: profile_url as! String)!
        }
        if let background_url = user["profile_background_image_url_https"] {
            backgroundURL = URL(string: background_url as! String)!
        }
        followerCount = user["followers_count"] as? Int
        followingCount = user["friends_count"] as? Int
        tweetCount = user["statuses_count"] as? Int
        tagline = user["description"] as? String
        
        self.dictionary = user
    }
    
    static let userDidLogoutNotification = NSNotification.Name.init(rawValue: "UserDidLogout")
    
    static var _current: User?
    
    class var current: User? {
        get {
            if _current == nil {
                let defaults = UserDefaults.standard
                let userData = defaults.object(forKey: "currentUserData") as? Data
            
                if let userData = userData {
                    let dictionary = try! JSONSerialization.jsonObject(with: userData, options: []) as! NSDictionary
                    _current = User(dictionary)
                }
            }
            
            return _current
        }
        
        set(user) {
            _current = user
            
            let defaults = UserDefaults.standard
            
            if let user = user {
                let data = try! JSONSerialization.data(withJSONObject: user.dictionary!, options: [])
                defaults.set(data, forKey: "currentUserData")
            } else {
                defaults.set(nil, forKey: "currentUserData")
            }
            defaults.synchronize()
        }
    }
}
