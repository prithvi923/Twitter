//
//  MenuViewController.swift
//  Twitter
//
//  Created by Prithvi Prabahar on 10/7/17.
//  Copyright © 2017 Prithvi Prabahar. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    let menuItems = ["Home", "Profile", "Mentions"]
    var menuItemControllers: [UIViewController]!
    
    var containerViewController: ContainerViewController! {
        didSet {
            containerViewController.contentViewController = menuItemControllers[0]
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 150
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        menuItemControllers = []
        menuItemControllers.append(storyboard.instantiateViewController(withIdentifier: "TweetsNavigationController"))
        let profileNavVC = storyboard.instantiateViewController(withIdentifier: "TweetsNavigationController") as! UINavigationController
        let profileVC = profileNavVC.viewControllers.first as! TweetsViewController
        profileVC.isProfile = true
        menuItemControllers.append(profileNavVC)
        menuItemControllers.append(storyboard.instantiateViewController(withIdentifier: "mentionsViewController"))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.s
    }
}
