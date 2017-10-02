//
//  ComposeViewController.swift
//  Twitter
//
//  Created by Prithvi Prabahar on 9/30/17.
//  Copyright © 2017 Prithvi Prabahar. All rights reserved.
//

import UIKit

class ComposeViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var characterCountLabel: UILabel!
    
    var replyToTweet: Tweet!
    var characterCount: Int = 140 {
        didSet {
            characterCountLabel.text = "\(characterCount)"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textView.delegate = self
        textView.text = "What's happening?"
        textView.textColor = UIColor.lightGray
        
        let tweetButton = UIButton(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 50))
        tweetButton.setTitle("Tweet", for: .normal)
        tweetButton.setTitleColor(.white, for: .normal)
        tweetButton.backgroundColor = UIColor(red: 29/255, green: 161/255, blue: 242/255, alpha: 1.0)
        tweetButton.addTarget(self, action: #selector(tweet), for: .touchUpInside)
        textView.inputAccessoryView = tweetButton
        
        textView.becomeFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func closeCompose(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func tweet() {
        let client = TwitterClient.sharedInstance
        if let tweet = replyToTweet {
            let completeStatus = "@\(tweet.screenName!) \(textView.text!)"
            client?.reply(to: tweet, withStatus: completeStatus, success: {
                self.dismiss(animated: true, completion: nil)
            }, failure: { (error: Error) in
                print("error: \(error.localizedDescription)")
            })
        } else {
            client?.tweet(textView.text, success: { (tweet: Tweet) in
                self.dismiss(animated: true, completion: nil)
            }, failure: { (error: Error) in
                print("error: \(error.localizedDescription)")
            })
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ComposeViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Placeholder"
            textView.textColor = UIColor.lightGray
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let count = textView.text.characters.count
        characterCount = 140 - count
    }
    
}
