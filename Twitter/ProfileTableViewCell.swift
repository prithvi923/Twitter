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
    @IBOutlet weak var descriptionView: UIView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var pageControl: UIPageControl!
    
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
        descriptionLabel.text = user.tagline
        pageControl.currentPage = 0
    }
    
    func page(toRight: Bool) {
        var newAlpha: CGFloat!
        var newPage: Int!
        if toRight {
            newAlpha = 0
            newPage = 0
        } else {
            newAlpha = 0.7
            newPage = 1
        }
        UIView.animate(withDuration: 0.5, animations: {
            self.descriptionView.alpha = newAlpha
            self.pageControl.currentPage = newPage
        })
    }

}
