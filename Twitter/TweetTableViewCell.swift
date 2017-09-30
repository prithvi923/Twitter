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
    
    var tweet: Tweet! {
        didSet {
            updateLabels()
        }
    }
    
    func updateLabels() {
        tweetLabel.text = tweet.text
        profileImageView.setImageWith(tweet.profileURL!)
        profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width/2
        profileImageView.clipsToBounds = true
        nameLabel.text = tweet.username
        timestampLabel.text = timeAgoSinceDate()
        handleLabel.text = "@\(tweet.screenName!)"
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // https://gist.github.com/minorbug/468790060810e0d29545
    
    func timeAgoSinceDate() -> String {
        let dateFormatter = DateFormatter()
        // "Tue Aug 28 21:16:23 +0000 2012"
        dateFormatter.dateFormat = "EEE MMM d HH:mm:ss Z yyyy"
        
        let timestamp = tweet.timestamp
        let date = dateFormatter.date(from: timestamp!)
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
    
}
