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
    var tagline: String?
    
    init(_ user: NSDictionary) {
        name = user["name"] as? String
        screenName = user["screen_name"] as? String
        if let profile_url = user["profile_url"] {
            profileURL = URL(string: profile_url as! String)!
        }
        tagline = user["description"] as? String
    }
}
