//
//  TweetTableViewController.swift
//  SmashTag
//
//  Created by Braden Gray on 11/20/16.
//  Copyright © 2016 Graycode. All rights reserved.
//

import UIKit
import Twitter
import CoreData

class TweetTableViewController: UITableViewController, UITextFieldDelegate {
    
//    var managedObjectContext: NSManagedObjectContext? =
//        (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    
    var managedDocument: UIManagedDocument?
    
    private func createAndOpenUIManagedObject() {
        let fileMangager = FileManager.default
        if let documentDirectory = fileMangager.urls(for: .documentDirectory, in: .userDomainMask).first {
            let url = documentDirectory.appendingPathComponent("SmashTag")
            let document = UIManagedDocument(fileURL: url)
            if document.documentState == .normal {
                managedDocument = document
            } else if document.documentState == .closed {
                let path = document.fileURL.path
                let fileExists = FileManager.default.fileExists(atPath: path)
                weak var weakSelf = self
                if fileExists {
                    document.open(completionHandler: { (success) in
                        if success {
                            weakSelf?.managedDocument = document
                        } else {
                            //Can't use core data do something
                        }
                    })
                } else {
                    document.save(to: document.fileURL, for: .forCreating, completionHandler: { (success) in
                        if success {
                            weakSelf?.managedDocument = document
                        } else {
                            //Can't use core data do something
                        }
                    })
                }
            }
        } else {
            //Can't use core data do something
        }
    }
    
    var tweets = [Array<Twitter.Tweet>]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    struct Constants {
        static let SearchTextKey = "SearchText"
    }
    
    private func storeSearchTextInUserDefaults(searchText: String) {
        let defaults = UserDefaults.standard
        
        var mutableValues: [String]?
        if let values = defaults.array(forKey: Constants.SearchTextKey) as? [String] {
            mutableValues = values
            if values.contains(searchText) {
                mutableValues!.remove(at: mutableValues!.index(of: searchText)!)
            }
            mutableValues!.insert(searchText, at: 0)
        } else {
            mutableValues = [searchText]
        }
        defaults.set(mutableValues, forKey: Constants.SearchTextKey)
        defaults.synchronize()
    }
    
    var searchText: String? {
        didSet {
            tweets.removeAll()
            searchForTweets()
            storeSearchTextInUserDefaults(searchText: searchText!)
        }
    }
    
    private var twitterRequest: Twitter.Request? {
        if var query = searchText, !query.isEmpty {
            if query.hasPrefix("@") {
                query = query + " OR from:" + query
            }
            return Twitter.Request(search: query + " -filter:retweets", count: 100)
        }
        return nil
    }
    
    private var lastTwitterRequest: Twitter.Request?
    
    private func searchForTweets() {
        if let request = twitterRequest {
            lastTwitterRequest = request
            request.fetchTweets({ [weak weakSelf = self] (newTweets) in
                DispatchQueue.main.async {
                    if request == weakSelf?.lastTwitterRequest {
                        if !newTweets.isEmpty {
                            weakSelf?.tweets.insert(newTweets, at: 0)
                            weakSelf?.updateDatabase(newTweets: newTweets)
                        }
                    }
                    weakSelf?.refreshControl?.endRefreshing()
                }
            })
        } else {
            self.refreshControl?.endRefreshing()
        }
    }
    
    private func updateDatabase(newTweets: [Tweet]) {
        managedDocument?.managedObjectContext.perform {
            for twitterInfo in newTweets {
                _ = TweetData.tweetWithTwitterInfo(twitterInfo: twitterInfo, inManagedObjectContext: self.managedDocument!.managedObjectContext)
            }
//            do {
//                try self.managedObjectContext?.save()
//            } catch let error {
//                print("Core Data Error: \(error)")
//            }
        }
    }
    
//    private func printDatabaseStatistics() {
//        managedObjectContext?.perform {
//            if let results = try? self.managedObjectContext!.execute(NSFetchRequest<NSFetchRequestResult>(entityName: "TwitterUser")) {
//                print("\(results.count) TwitterUsers")
//            }
//            let tweetCount = try? self.managedObjectContext!.count(for: NSFetchRequest(entityName: "TweetData")) {
//                print("\(tweetCount) Tweets")
//            }
//        }
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        createAndOpenUIManagedObject()
        if let first = navigationController?.viewControllers.first as? TweetTableViewController {
            if first == self {
                var barButtons: [UIBarButtonItem] = []
                for button in navigationItem.rightBarButtonItems! {
                    if button.title != "Home" {
                        barButtons.append(button)
                    }
                }
                navigationItem.setRightBarButtonItems(barButtons, animated: true)
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return tweets.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tweets[section].count
    }

    private struct Storyboard {
        static let TweetCellIdentifier = "Tweet"
        static let ShowDetailSegue = "Show Detail"
        static let ShowImagesSegue = "Show Images"
        static let ShowTweetersSegue = "TweetersMentioningSearchTerm"
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.TweetCellIdentifier, for: indexPath)

        let tweet = tweets[indexPath.section][indexPath.row]
        if let tweetCell = cell as? TweetTableViewCell {
            tweetCell.tweet = tweet
        }

        return cell
    }
    
    @IBOutlet weak var searchTextField: UITextField! {
        didSet {
            searchTextField.delegate = self
            searchTextField.text = searchText
        }
    }
    
    @IBAction func showImages(_ sender: UIBarButtonItem) {
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        searchText = textField.text
        return true
    }
    
    @IBAction func refresh(_ sender: UIRefreshControl) {
        searchForTweets()
    }
    
    @IBAction func unwindToRoot(sender: UIStoryboardSegue) {}

    override func canPerformUnwindSegueAction(_ action: Selector, from fromViewController: UIViewController, withSender sender: Any) -> Bool {
        if let first = navigationController?.viewControllers.first as? TweetTableViewController {
            if first == self {
                return true
            }
        }
        return false
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == Storyboard.ShowDetailSegue {
            if let tmvc = segue.destination as? TweetMentionsTableViewController {
                if let cell = sender as? UITableViewCell {
                    let indexPath = tableView.indexPath(for: cell)
                    tmvc.tweet = tweets[(indexPath?.section)!][(indexPath?.row)!]
                }
            }
        } else if segue.identifier == Storyboard.ShowImagesSegue {
            if let icvc = segue.destination as? ImageCollectionViewController {
                icvc.tweets = tweets
                icvc.title = "Images"
            }
        } else if segue.identifier == Storyboard.ShowTweetersSegue {
            if let tweetersTVC = segue.destination as? TweetersTableViewController {
                tweetersTVC.mention = searchText
                tweetersTVC.managedObjectContext = managedDocument?.managedObjectContext
            }
        }
    }
}
