//
//  TweetDetailViewController.swift
//  Twitter
//
//  Created by Prithvi Prabahar on 9/30/17.
//  Copyright © 2017 Prithvi Prabahar. All rights reserved.
//

import UIKit

class TweetDetailViewController: UIViewController {
    
    var tweet: Tweet!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var favoritesLabel: UILabel!
    @IBOutlet weak var retweetLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var replyButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        nameLabel.text = tweet.username
        screenNameLabel.text = "@\(tweet.screenName!)"
        tweetLabel.text = tweet.text
        profileImageView.setImageWith(tweet.profileURL!)
        timestampLabel.text = tweet.detailTime()
        retweetLabel.text = "\(tweet.retweetCount!)"
        favoritesLabel.text = "\(tweet.favoriteCount!)"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func retweetPressed(_ sender: Any) {
        if (!tweet.retweeted!) {
            TwitterClient.sharedInstance.retweet(tweet, success: { (tweet: Tweet) in
                self.retweetButton.isHighlighted = true
                self.tweet.retweetCount! += 1
                self.retweetLabel.text = "\(self.tweet.retweetCount!)"
                self.tweet = tweet
            }, failure: { (error: Error) in
                print("error: \(error.localizedDescription)")
            })
        } else {
            TwitterClient.sharedInstance.unretweet(tweet, success: { (tweet: Tweet) in
                self.retweetButton.isHighlighted = false
                self.tweet.retweetCount! -= 1
                self.retweetLabel.text = "\(self.tweet.retweetCount!)"
                self.tweet = tweet
            }, failure: { (error: Error) in
                print("error: \(error.localizedDescription)")
            })
        }
    }
    
    @IBAction func favoritePressed(_ sender: Any) {
        if (!tweet.favorited!) {
            TwitterClient.sharedInstance.favorite(tweet, success: { () in
                self.favoriteButton.isHighlighted = true
                self.tweet.favoriteCount! += 1
                self.favoritesLabel.text = "\(self.tweet.favoriteCount!)"
                self.tweet.favorited = true
            }, failure: { (error: Error) in
                print("error: \(error.localizedDescription)")
            })
        } else {
            TwitterClient.sharedInstance.unfavorite(tweet, success: { () in
                self.favoriteButton.isHighlighted = false
                self.tweet.favoriteCount! -= 1
                self.favoritesLabel.text = "\(self.tweet.favoriteCount!)"
                self.tweet.favorited = false
            }, failure: { (error: Error) in
                print("error: \(error.localizedDescription)")
            })
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destVC = segue.destination as! ComposeViewController
        destVC.replyToTweet = tweet
    }

}
