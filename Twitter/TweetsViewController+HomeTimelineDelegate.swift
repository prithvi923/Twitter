//
//  TweetsViewController+HomeTimelineDelegate.swift
//  Twitter
//
//  Created by Prithvi Prabahar on 10/8/17.
//  Copyright © 2017 Prithvi Prabahar. All rights reserved.
//

import Foundation

extension TweetsViewController: HomeTimelineDelegate {
    
    func current(tweets: [Tweet]) {
        self.tweets = tweets
        self.tableView.reloadData()
    }
    
    func new(tweets: [Tweet]) {
        self.tweets.insert(contentsOf: tweets, at: 0)
        self.tableView.reloadData()
    }
    
    func old(tweets: [Tweet]) {
        self.tweets.append(contentsOf: tweets)
        self.tableView.reloadData()
    }
}
