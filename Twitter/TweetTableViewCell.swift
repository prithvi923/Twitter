//
//  TweetTableViewCell.swift
//  Twitter
//
//  Created by Prithvi Prabahar on 9/29/17.
//  Copyright © 2017 Prithvi Prabahar. All rights reserved.
//

import UIKit

class TweetTableViewCell: UITableViewCell {

    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var handleLabel: UILabel!
    
    var delegate: TweetsViewController!
    
    var tweet: Tweet! {
        didSet {
            updateLabels()
        }
    }
    
    func updateLabels() {
        tweetLabel.text = tweet.text
        profileImageView.setImageWith(tweet.user!.profileURL!)
        
        profileImageView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showProfile))
        profileImageView.addGestureRecognizer(tapGesture)
        
        nameLabel.text = tweet.user!.name
        timestampLabel.text = tweet.timeAgoSinceDate()
        handleLabel.text = "@\(tweet.user!.screenName!)"
    }
    
    @objc func showProfile() {
        delegate.pushProfile(user: tweet.user!)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
