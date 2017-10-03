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
    }
    
    func favorite() {
        self.favoriteButton.isHighlighted = true
        self.tweet.favoriteCount! += 1
        self.favoritesLabel.text = "\(self.tweet.favoriteCount!)"
        self.tweet.favorited = true
    }
    
    func unfavorite() {
        self.favoriteButton.isHighlighted = false
        self.tweet.favoriteCount! -= 1
        self.favoritesLabel.text = "\(self.tweet.favoriteCount!)"
        self.tweet.favorited = false
    }
    
}
