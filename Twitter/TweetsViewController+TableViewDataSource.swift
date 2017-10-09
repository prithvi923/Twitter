//
//  TweetsViewController+TableViewDataSource.swift
//  Twitter
//
//  Created by Prithvi Prabahar on 10/8/17.
//  Copyright © 2017 Prithvi Prabahar. All rights reserved.
//

import UIKit

extension TweetsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if isProfile {
            return 2
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isProfile && section == 0 {
            return 1
        }
        return tweets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (isProfile && indexPath.section == 0) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell") as! ProfileTableViewCell
            if user != nil {
                cell.user = user
            } else {
                cell.user = User.current
            }
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell") as! TweetTableViewCell
        cell.tweet = tweets[indexPath.row]
        cell.delegate = self
        return cell
    }
}
