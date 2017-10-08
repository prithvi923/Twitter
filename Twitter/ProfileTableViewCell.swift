//
//  ProfileTableViewCell.swift
//  Twitter
//
//  Created by Prithvi Prabahar on 10/8/17.
//  Copyright © 2017 Prithvi Prabahar. All rights reserved.
//

import UIKit

class ProfileTableViewCell: UITableViewCell {

    
    @IBOutlet weak var headerImageView: UIImageView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var tweetCountLabel: UILabel!
    @IBOutlet weak var followingCountLabel: UILabel!
    @IBOutlet weak var followerCountLabel: UILabel!
    
    var user: User! {
        didSet {
            updateViews()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateViews() {
        headerImageView.setImageWith(user.backgroundURL!)
        profileImageView.setImageWith(user.profileURL!)
        nameLabel.text = user.name
        screenNameLabel.text = "@\(user.screenName!)"
        tweetCountLabel.text = "\(user.tweetCount!)"
        followingCountLabel.text = "\(user.followingCount!)"
        followerCountLabel.text = "\(user.followerCount!)"
    }

}
