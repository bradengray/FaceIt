//
//  TweetTableViewCell.swift
//  SmashTag
//
//  Created by Braden Gray on 11/20/16.
//  Copyright © 2016 Graycode. All rights reserved.
//

import UIKit
import Twitter

class TweetTableViewCell: UITableViewCell {
    
    @IBOutlet weak var tweetScreenNameLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var tweetCreatedLabel: UILabel!
    @IBOutlet weak var tweetProfileImageView: UIImageView!
    
    var tweet: Twitter.Tweet? {
        didSet {
            updateUI()
        }
    }
    
    private func updateUI() {
        //reset any existing tweet information
        tweetTextLabel?.attributedText = nil
        tweetScreenNameLabel?.attributedText = nil
        tweetProfileImageView?.image = nil
        tweetCreatedLabel?.attributedText = nil
        
        //load new information from out tweet (if any)
        if let tweet = self.tweet {
            tweetTextLabel?.text = tweet.text
            if tweetTextLabel?.text != nil {
                for _ in tweet.media {
                    tweetTextLabel.text! += " 📷"
                }
                
                let mutableString = NSMutableAttributedString(string: (tweetTextLabel?.text)!)
                
                for hashtag in tweet.hashtags {
                    mutableString.addAttributes([NSForegroundColorAttributeName : UIColor.orange], range: hashtag.nsrange)
                }
                
                for url in tweet.urls {
                    mutableString.addAttributes([NSForegroundColorAttributeName: UIColor.blue], range: url.nsrange)
                }
                
                for mention in tweet.userMentions {
                    mutableString.addAttributes([NSForegroundColorAttributeName : UIColor.brown], range: mention.nsrange)
                }
                
                tweetTextLabel?.attributedText = mutableString
            }
            
            tweetScreenNameLabel?.text = "\(tweet.user)" //tweet.user.description
            
            if let profileImageURL = tweet.user.profileImageURL {
                weak var weakSelf = self
                DispatchQueue.global(qos: .userInitiated).async { //Should make sure this is still the same tweet.
                    let contentsOfURL = NSData(contentsOf: profileImageURL)
                    DispatchQueue.main.async {
                        if let imageData = contentsOfURL {
                            weakSelf?.tweetProfileImageView.image = UIImage(data: imageData as Data)
                        }
                    }
                }
            }
            
            let formatter = DateFormatter()
            if NSDate().timeIntervalSince(tweet.created) > 24*60*60 {
                formatter.dateStyle = DateFormatter.Style.short
            } else {
                formatter.timeStyle = DateFormatter.Style.short
            }
            tweetCreatedLabel?.text = formatter.string(from: tweet.created)
        }
        
    }
}
