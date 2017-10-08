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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        
        if isProfile {
            client.userDelegate = self
            client.userTimeline()
        } else if isMentions {
            client.mentionsDelegate = self
            client.mentionsTimeline()
        } else {
            client.homeDelegate = self
            client.homeTimeline()
        }
        
        userImageView.setImageWith((User.current?.profileURL)!)
        
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
    
}

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
            cell.user = User.current
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell") as! TweetTableViewCell
        cell.tweet = tweets[indexPath.row]
        return cell
    }
}

extension TweetsViewController: UITableViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (!isMoreDataLoading) {
            let scrollViewContentHeight = tableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
        
            if(scrollView.contentOffset.y > scrollOffsetThreshold && tableView.isDragging) {
                isMoreDataLoading = true
            
                let frame = CGRect(x: 0, y: tableView.contentSize.height, width: tableView.bounds.size.width, height: InfiniteScrollActivityView.defaultHeight)
                loadingMoreView?.frame = frame
                loadingMoreView!.startAnimating()
            
                self.client.olderTweets(than: tweets.last!.id!, completion: {
                    self.loadingMoreView!.stopAnimating()
                    self.isMoreDataLoading = false
                })
            }
        }
    }
}

extension TweetsViewController: HomeTimelineDelegate {
    
    func current(tweets: [Tweet]) {
        self.tweets = tweets
        self.tableView.reloadData()
    }
    
    func new(tweets: [Tweet]) {
        self.tweets.insert(contentsOf: tweets, at: 0)
        self.tableView.reloadData()
    }
    
    func old(tweets: [Tweet]) {
        self.tweets.append(contentsOf: tweets)
        self.tableView.reloadData()
    }
}
