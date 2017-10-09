//
//  TweetsViewController+TableViewDelegate.swift
//  Twitter
//
//  Created by Prithvi Prabahar on 10/8/17.
//  Copyright © 2017 Prithvi Prabahar. All rights reserved.
//

import UIKit

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
