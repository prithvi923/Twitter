//
//  MenuViewController+TableViewDelegate.swift
//  Twitter
//
//  Created by Prithvi Prabahar on 10/7/17.
//  Copyright © 2017 Prithvi Prabahar. All rights reserved.
//

import UIKit

extension MenuViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        containerViewController.contentViewController = menuItemControllers[indexPath.row]
    }
}
