//
//  TweetsViewController.swift
//  Twitter
//
//  Created by Prithvi Prabahar on 9/29/17.
//  Copyright © 2017 Prithvi Prabahar. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController {

    var tweets: [Tweet] = []
    var isMoreDataLoading = false
    var loadingMoreView:InfiniteScrollActivityView?
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var userImageView: ProfileImageView!
    
    var isProfile: Bool = false
    var isMentions: Bool = false
    var client = TwitterClient.sharedInstance
    var user: User!
    var originalAlpha: CGFloat!
    var profileCell: ProfileTableViewCell!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        
        if isProfile {
            client.userDelegate = self
            if let user = user {
                client.userTimeline(user: user)
            } else {
                client.userTimeline(user: User.current!)
            }
        } else if isMentions {
            client.mentionsDelegate = self
            client.mentionsTimeline()
        } else {
            client.homeDelegate = self
            client.homeTimeline()
        }
        
        if user != nil {
            let backButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(close))
            navigationItem.leftBarButtonItem = backButton
        } else {
            userImageView.setImageWith((User.current?.profileURL)!)
        }
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(pullToRefresh(_:)), for: .valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
        
        let frame = CGRect(x: 0, y: tableView.contentSize.height, width: tableView.bounds.size.width, height: InfiniteScrollActivityView.defaultHeight)
        loadingMoreView = InfiniteScrollActivityView(frame: frame)
        loadingMoreView!.isHidden = true
        tableView.addSubview(loadingMoreView!)
        
        var insets = tableView.contentInset
        insets.bottom += InfiniteScrollActivityView.defaultHeight
        tableView.contentInset = insets
    }
    
    func close() {
        navigationController?.popViewController(animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func logoutPressed(_ sender: Any) {
        TwitterClient.sharedInstance.logout()
    }
    
    func pullToRefresh(_ refreshControl: UIRefreshControl) {
        client.newerTweets(than: tweets[0].id!, completion: {
            refreshControl.endRefreshing()
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "tweetDetailSegue") {
            let destVC = segue.destination as! TweetDetailViewController
            let cell = sender as! TweetTableViewCell
            cell.setSelected(false, animated: true)
            destVC.tweet = cell.tweet
        }
    }
    
    @IBAction func unwindFromComposeToTweetVC(segue:UIStoryboardSegue) {
        
    }
    
    func pushProfile(user: User) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let profileVC = storyboard.instantiateViewController(withIdentifier: "TweetsViewController") as! TweetsViewController
        profileVC.isProfile = true
        profileVC.user = user
        navigationController?.pushViewController(profileVC, animated: true)
    }
    
    @IBAction func swipeHeaderImage(_ sender: UIPanGestureRecognizer) {
        let velocity = sender.velocity(in: view)
        
        if sender.state == .ended {
            profileCell.page(toRight: velocity.x > 0)
        }
    }
    
}
