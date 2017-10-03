//
//  TweetDetailViewController+TweetEngageDelegate.swift
//  Twitter
//
//  Created by Prithvi Prabahar on 10/2/17.
//  Copyright © 2017 Prithvi Prabahar. All rights reserved.
//

import Foundation

extension TweetDetailViewController: TweetEngageDelegate {
    
    func updateEngagement() {
        self.retweetButton.isHighlighted = self.tweet.retweeted!
        self.retweetLabel.text = "\(self.tweet.retweetCount!)"
        
        self.favoriteButton.isHighlighted = self.tweet.favorited!
        self.favoritesLabel.text = "\(self.tweet.favoriteCount!)"
    }
}
