//
//  TweetDetailViewController+TweetEngageDelegate.swift
//  Twitter
//
//  Created by Prithvi Prabahar on 10/2/17.
//  Copyright © 2017 Prithvi Prabahar. All rights reserved.
//

import Foundation

extension TweetDetailViewController: TweetEngageDelegate {

    func retweet(tweet: Tweet) {
        self.retweetButton.isHighlighted = true
        self.tweet.retweetCount! += 1
        self.retweetLabel.text = "\(self.tweet.retweetCount!)"
        self.tweet = tweet
    }
    
    func unretweet(tweet: Tweet) {
        self.retweetButton.isHighlighted = false
        self.tweet.retweetCount! -= 1
        self.retweetLabel.text = "\(self.tweet.retweetCount!)"
        self.tweet = tweet
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
