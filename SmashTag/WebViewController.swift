//
//  WebViewController.swift
//  SmashTag
//
//  Created by Braden Gray on 11/25/16.
//  Copyright © 2016 Graycode. All rights reserved.
//

import UIKit

class WebViewController: UIViewController, UIWebViewDelegate {

    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        let barButton = UIBarButtonItem(barButtonSystemItem: .reply, target: self, action: #selector(WebViewController.back(_:)))
//        navigationItem.setRightBarButton(barButton, animated: true)
        webView.scalesPageToFit = true
        webView.delegate = self
        loadURL()
    }
    
    var url: NSURL? {
        didSet {
            if view.window != nil {
                loadURL()
            }
        }
    }
    
    private func loadURL() {
        if url != nil {
            webView.loadRequest(URLRequest(url: url! as URL))
        }
    }
    
    var activeDownloads = 0
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        spinner.startAnimating()
        activeDownloads += 1
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        activeDownloads -= 1
        if activeDownloads < 1 {
            spinner.stopAnimating()
        }
    }

    @IBAction func back(_ sender: UIBarButtonItem) {
        webView.goBack()
    }
//    @IBOutlet func back(_ sender: UIBarButtonItem) {
//        webView.goBack()
//    }
}
