//
//  ProfileImageView.swift
//  Twitter
//
//  Created by Prithvi Prabahar on 10/2/17.
//  Copyright © 2017 Prithvi Prabahar. All rights reserved.
//

import UIKit

class ProfileImageView: UIImageView {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        layer.cornerRadius = frame.size.width/2
        clipsToBounds = true
    }

}
