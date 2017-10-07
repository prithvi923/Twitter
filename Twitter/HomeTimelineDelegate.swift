//
//  HomeTimelineDelegate.swift
//  Twitter
//
//  Created by Prithvi Prabahar on 10/5/17.
//  Copyright © 2017 Prithvi Prabahar. All rights reserved.
//

import Foundation

protocol HomeTimelineDelegate {
    func current(tweets: [Tweet])
    func new(tweets: [Tweet])
    func old(tweets: [Tweet])
}
