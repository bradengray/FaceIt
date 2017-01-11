//
//  ImageCollectionViewCell.swift
//  SmashTag
//
//  Created by Braden Gray on 11/26/16.
//  Copyright © 2016 Graycode. All rights reserved.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    var imageURL: NSURL? {
        didSet {
            backgroundColor = UIColor.darkGray
            image = nil
            fetchImage()
        }
    }
    
    private var image: UIImage? {
        get {
            return imageView.image
        }
        set {
            imageView.image = newValue
            spinner.stopAnimating()
        }
    }
    
    private func fetchImage() {
        if let url = imageURL {
            spinner.startAnimating()
            
            weak var weakSelf = self
            DispatchQueue.global(qos: .userInitiated).async {
                if url == weakSelf?.imageURL {
                    let contentsOfURL = NSData(contentsOf: url as URL)
                    DispatchQueue.main.async {
                        if let imageData = contentsOfURL {
                            weakSelf?.image = UIImage(data: imageData as Data)
                        }
                    }
                } else {
                    weakSelf?.spinner.stopAnimating()
                }
            }
        }
    }
    
}
