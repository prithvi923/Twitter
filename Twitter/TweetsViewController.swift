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
    @IBOutlet weak var userImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        
        TwitterClient.sharedInstance?.homeTimeline( success: { (tweets: [Tweet]) in
            self.tweets = tweets
            self.tableView.reloadData()
        }, failure: { (error: Error) in
            print("error: \(error.localizedDescription)")
        })
        
        userImageView.setImageWith((User.current?.profileURL)!)
        userImageView.layer.cornerRadius = self.userImageView.frame.size.width/2
        userImageView.clipsToBounds = true
        
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
        TwitterClient.sharedInstance?.logout()
    }
    
    func pullToRefresh(_ refreshControl: UIRefreshControl) {
        TwitterClient.sharedInstance?.newerTweets(than: tweets[0].id!, success: { (tweets: [Tweet]) in
            self.tweets.insert(contentsOf: tweets, at: 0)
            self.tableView.reloadData()
            refreshControl.endRefreshing()
        }, failure: { (error: Error) in
            print("error: \(error.localizedDescription)")
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
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
            
                TwitterClient.sharedInstance?.olderTweets(than: tweets.last!.id!, success: { (tweets: [Tweet]) in
                    self.tweets.append(contentsOf: tweets)
                    self.tableView.reloadData()
                    self.loadingMoreView!.stopAnimating()
                    self.isMoreDataLoading = false
                }, failure: { (error: Error) in
                    print("error: \(error.localizedDescription)")
                    self.loadingMoreView!.stopAnimating()
                    self.isMoreDataLoading = false
                })
            }
        }
    }
}
