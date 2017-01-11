//
//  ImageCollectionViewController.swift
//  SmashTag
//
//  Created by Braden Gray on 11/26/16.
//  Copyright © 2016 Graycode. All rights reserved.
//

import UIKit
import Twitter

private let reuseIdentifier = "Cell"

class ImageCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var tweets : [[Tweet]] = [] {
        didSet {
            images = tweets.reduce([], +)
                .map { tweet in
                    tweet.media.map {TweetMedia(tweet: tweet, media: $0) }
                }.reduce([], +)
        }
    }
    
    private var images = [TweetMedia]()
    
    private struct TweetMedia {
        var tweet: Tweet
        var media: MediaItem
    }
    
    private struct Storyboard {
        static let ImageCollectionViewIdentifier = "Image Cell"
        static let CellArea: CGFloat = 4000
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register cell classes
//        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: Storyboard.ImageCollectionViewIdentifier)

        // Do any additional setup after loading the view.
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return images.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Storyboard.ImageCollectionViewIdentifier , for: indexPath)
        
        if let imageCell = cell as? ImageCollectionViewCell {
            let media = images[indexPath.row].media
            imageCell.imageURL = media.url as NSURL?
            
            return imageCell
        }
        
        return cell
    }
    
    // MARK: UICollectionViewDelegateFlowLayout
    
    var scale: CGFloat = 1 { didSet { collectionView?.collectionViewLayout.invalidateLayout() } }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let ratio = CGFloat(images[indexPath.row].media.aspectRatio)
        let width = min(sqrt(ratio * Storyboard.CellArea) * scale, collectionView.bounds.size.width)
        let height = width / ratio
        return CGSize(width: width, height: height)
    }
}
