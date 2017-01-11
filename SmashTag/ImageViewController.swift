//
//  ImageViewController.swift
//  Cassini
//
//  Created by Braden Gray on 11/19/16.
//  Copyright © 2016 Graycode. All rights reserved.
//

import UIKit
import Twitter

class ImageViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            scrollView.contentSize = imageView.frame.size
            scrollView.delegate = self
            scrollView.minimumZoomScale = 0.35
            scrollView.maximumZoomScale = 1.5
            autoZoomToFit()
        }
    }
    
    private func autoZoomToFit() {
        scrollView.zoom(to: CGRect(x: 0, y: 0, width: (imageView.image?.size.width)!, height: 0), animated: true)
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator:
        UIViewControllerTransitionCoordinator) {
        weak var weakSelf = self
        coordinator.animate(alongsideTransition: { (UIViewControllerTransitionCoordinatorContext) in
            weakSelf?.autoZoomToFit()
        }, completion: nil)
    }
    
    private var imageView = UIImageView()
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    var image: UIImage? {
        get {
            return imageView.image
        }
        set {
            imageView.image = newValue
            imageView.sizeToFit()
            scrollView?.contentSize = imageView.frame.size
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.addSubview(imageView)
    }
    
}
