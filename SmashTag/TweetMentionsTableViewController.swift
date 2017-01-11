//
//  TweetMentionsTableViewController.swift
//  SmashTag
//
//  Created by Braden Gray on 11/21/16.
//  Copyright © 2016 Graycode. All rights reserved.
//

import UIKit
import Twitter

class TweetMentionsTableViewController: UITableViewController {

    var tweet: Twitter.Tweet? {
        didSet {
            
            var users = ["@" + (tweet?.user.screenName)!]
            for mention: Mention in (tweet?.userMentions)! {
               users.append(mention.keyword)
            }
            
            mentions = [
                Section(Cells: (tweet?.media)!, CellType: CellType.Media(StoryBoard.MediaCellIdentifier), Title: "Images"),
                Section(Cells: (tweet?.hashtags)!, CellType: CellType.Text(StoryBoard.TextCellIdentifier), Title: "Hashtags"),
                Section(Cells: (tweet?.urls)!, CellType: CellType.Text(StoryBoard.TextCellIdentifier), Title: "Urls"),
                Section(Cells: users as [AnyObject], CellType: CellType.Text(StoryBoard.TextCellIdentifier), Title: "Users")
            ]
        }
    }
    
    private var mentions = [Section]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    private struct Section {
        var Cells: [AnyObject]
        var CellType: CellType
        var Title: String
    }
    
    private enum CellType {
        case Media(String)
        case Text(String)
    }
    
    private struct StoryBoard {
        static let MediaCellIdentifier = "Media"
        static let TextCellIdentifier = "Text"
        static let MediaSegueIdentifier = "Show Image"
        static let NewSearchSegueIdentifier = "New Search"
        static let ShowWebSegueIdentifier = "Show Web"
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return mentions.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return mentions[section].Cells.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch mentions[indexPath.section].CellType {
        case .Media(let value):
            let cell = tableView.dequeueReusableCell(withIdentifier: value, for: indexPath) as? MediaTableViewCell
            cell?.media = mentions[indexPath.section].Cells[indexPath.row] as? MediaItem
            return cell!
        case .Text(let value):
            let cell = tableView.dequeueReusableCell(withIdentifier: value, for: indexPath)
            if let mention = mentions[indexPath.section].Cells[indexPath.row] as? Mention {
                cell.textLabel?.text = mention.keyword
            } else {
                cell.textLabel?.text = mentions[indexPath.section].Cells[indexPath.row] as? String
            }
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if mentions[section].Cells.count != 0 {
            return mentions[section].Title
        } else {
            return ""
        }
    }
    
    //MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            if let media = mentions[indexPath.section].Cells[indexPath.row] as? MediaItem {
                return tableView.bounds.size.width / CGFloat(media.aspectRatio)
            }
        }
        return UITableViewAutomaticDimension
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 2 {
            if let cell = tableView.cellForRow(at: indexPath) {
                performSegue(withIdentifier: StoryBoard.ShowWebSegueIdentifier, sender: cell)
            }
//            if let mention = mentions[indexPath.section].Cells[indexPath.row] as? Mention {
//                if let url = NSURL(string: mention.keyword) {
//                    UIApplication.shared.open(url as URL)
//                }
//            }
        }
    }

    // MARK: - Navigation
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if let cell = sender as? UITableViewCell {
            if let indexPath = tableView.indexPath(for: cell) {
                if indexPath.section == 2 {
                    return false
                }
            }
        }
        return true
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == StoryBoard.MediaSegueIdentifier {
            if let ivc = segue.destination as? ImageViewController {
                if let cell = sender as? MediaTableViewCell {
                    ivc.image = cell.mediaImageView.image
                }
            }
        } else if segue.identifier == StoryBoard.NewSearchSegueIdentifier {
            if let ttwc = segue.destination as? TweetTableViewController {
                if let cell = sender as? UITableViewCell {
                    ttwc.searchText = cell.textLabel?.text
                }
            }
        } else if segue.identifier == StoryBoard.ShowWebSegueIdentifier {
            if let wvc = segue.destination as? WebViewController {
                if let cell = sender as? UITableViewCell {
                    if let url = NSURL(string: (cell.textLabel?.text)!) {
                        wvc.url = url
                    }
                }
            }
        }
    }
}
