//
//  MediaTableViewCell.swift
//  SmashTag
//
//  Created by Braden Gray on 11/21/16.
//  Copyright © 2016 Graycode. All rights reserved.
//

import UIKit
import Twitter

class MediaTableViewCell: UITableViewCell {

    
    @IBOutlet weak var mediaImageView: UIImageView!
    
    var media: Twitter.MediaItem? {
        didSet {
           updateUI()
        }
    }
    
    private func updateUI() {
        if let url = media?.url {
            weak var weakSelf = self
            DispatchQueue.global(qos: .userInitiated).async {
                if url == weakSelf?.media?.url {
                    let contentsOfUrl = NSData(contentsOf: url)
                    DispatchQueue.main.async {
                        if let imageData = contentsOfUrl {
                            weakSelf?.mediaImageView?.image = UIImage(data: imageData as Data)
                        }
                    }
                }
            }
        }
    }

}
