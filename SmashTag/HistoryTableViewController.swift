//
//  HistoryTableViewController.swift
//  SmashTag
//
//  Created by Braden Gray on 11/25/16.
//  Copyright © 2016 Graycode. All rights reserved.
//

import UIKit

class HistoryTableViewController: UITableViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    private var searchHistory: [String]? {
        return UserDefaults.standard.array(forKey: TweetTableViewController.Constants.SearchTextKey) as! [String]?
    }
    
    private struct StoryBoard {
        static let SearchHistoryCell = "History Cell"
        static let SearchHistorySegue = "Old Search"
        static let ShowMentionsSegue = "Show Mentions"
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return (searchHistory?.count)!
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: StoryBoard.SearchHistoryCell, for: indexPath)
        if let data = searchHistory?[indexPath.row] {
            cell.textLabel?.text = data
        }
        return cell
    }
    
    private func removeDefaultAtIndex(at: Int) {
        let defaults = UserDefaults.standard
        if var values = defaults.array(forKey: TweetTableViewController.Constants.SearchTextKey) as? [String] {
            values.remove(at: at)
            defaults.set(values, forKey: TweetTableViewController.Constants.SearchTextKey)
            defaults.synchronize()
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            removeDefaultAtIndex(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == StoryBoard.SearchHistorySegue {
            if let cell = sender as? UITableViewCell {
                if let ttvc = segue.destination as? TweetTableViewController {
                    ttvc.searchText = cell.textLabel?.text
                }
            }
        } else if segue.identifier == StoryBoard.ShowMentionsSegue {
            if let cell = sender as? UITableViewCell {
                if let mtvc = segue.destination as? MentionsTableViewController {
                    mtvc.title = "All Mentions"
                    mtvc.mention = cell.textLabel?.text
                    if let ttvc = (tabBarController?.viewControllers?.first)?.contentViewController as? TweetTableViewController {
                        mtvc.managedObjectContext = ttvc.managedDocument?.managedObjectContext
                    }
                }
            }
        }
    }
}

extension UIViewController {
    var contentViewController: UIViewController {
        if let navCon = self as? UINavigationController {
            return navCon.visibleViewController ?? self
        } else {
            return self
        }
    }
}
