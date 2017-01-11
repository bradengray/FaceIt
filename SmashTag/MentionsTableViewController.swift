//
//  MentionsTableViewController.swift
//  SmashTag
//
//  Created by Braden Gray on 11/28/16.
//  Copyright © 2016 Graycode. All rights reserved.
//

import UIKit
import CoreData

class MentionsTableViewController: CoreDataTableViewController {

    var mention: String? { didSet { updateUI() } }
    var managedObjectContext: NSManagedObjectContext? { didSet { updateUI() } }
    
    private func updateUI() {
        if let context = managedObjectContext, (mention?.characters.count)! > 0 {
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "TweetMention")
            request.predicate = NSPredicate(format: "ANY tweets.text contains[c] %@", mention!)
            request.sortDescriptors = [
                NSSortDescriptor(
                    key: "count",
                    ascending: false
                ),
                NSSortDescriptor(
                    key: "keyWord",
                    ascending: true,
                    selector: #selector(NSString.localizedStandardCompare(_:))
                )
            ]
            fetchedResultsController = NSFetchedResultsController(
                fetchRequest: request,
                managedObjectContext: context,
                sectionNameKeyPath: nil,
                cacheName: nil
            )
        } else {
            fetchedResultsController = nil
        }
    }
    
    private struct Storyboard {
        static let MentionCellIdentifier = "Mention Cell"
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.MentionCellIdentifier, for: indexPath)
        
        if let mention = fetchedResultsController?.object(at: indexPath) as? TweetMention {
            var keyWord: String?
            var count: Int64?
            mention.managedObjectContext?.performAndWait {
                keyWord = mention.keyWord
                count = mention.count
            }
            cell.textLabel?.text = keyWord
            cell.detailTextLabel?.text = "Mentions: \(count!)"
        }
        return cell
    }
}
