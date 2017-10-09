//
//  ContainerViewController.swift
//  Twitter
//
//  Created by Prithvi Prabahar on 10/7/17.
//  Copyright © 2017 Prithvi Prabahar. All rights reserved.
//

import UIKit

class ContainerViewController: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var contentViewLeftMargingConstraint: NSLayoutConstraint!
    var originalLeftMargin: CGFloat!
    
    var menuViewController: MenuViewController! {
        didSet {
            menuViewController.willMove(toParentViewController: self)
            menuView.addSubview(menuViewController.view)
            menuViewController.didMove(toParentViewController: self)
        }
    }
    
    var contentViewController: UIViewController! {
        didSet(oldContentViewController) {
            
            if oldContentViewController != nil {
                oldContentViewController.willMove(toParentViewController: nil)
                oldContentViewController.view.removeFromSuperview()
                oldContentViewController.didMove(toParentViewController: nil)
            }
            
            contentViewController.willMove(toParentViewController: self)
            contentView.addSubview(contentViewController.view)
            contentViewController.didMove(toParentViewController: self)
            animateMenu(to: false)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        menuViewController = storyboard.instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
        menuViewController.containerViewController = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onShowMenu(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)
        let velocity = sender.velocity(in: view)
        
        if sender.state == .began {
            originalLeftMargin = contentViewLeftMargingConstraint.constant
        } else if sender.state == .changed {
            contentViewLeftMargingConstraint.constant = originalLeftMargin + translation.x
        } else if sender.state == .ended {
            animateMenu(to: velocity.x >= 0)
        }
    }
    
    func animateMenu(to: Bool) {
        var newConstant: CGFloat = 0.0
        if to {
            newConstant = 2/3 * view.frame.width
        } else {
            newConstant = 0
        }
        UIView.animate(withDuration: 1,
                       delay: 0,
                       usingSpringWithDamping: 0.8,
                       initialSpringVelocity: 3,
                       options: [],
                       animations: {
                        self.contentViewLeftMargingConstraint.constant = newConstant
                        self.view.layoutIfNeeded()
        },
                       completion: nil)
    }
}
