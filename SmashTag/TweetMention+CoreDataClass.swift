//
//  TweetMention+CoreDataClass.swift
//  SmashTag
//
//  Created by Braden Gray on 11/28/16.
//  Copyright © 2016 Graycode. All rights reserved.
//

import Foundation
import CoreData
import Twitter

@objc(TweetMention)
public class TweetMention: NSManagedObject {
    
    class func mentionWithTwitterInfo(twitterInfo: Mention, inManagedObjectContext context: NSManagedObjectContext)-> TweetMention? {
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "TweetMention")
        request.predicate = NSPredicate(format: "keyWord == %@", twitterInfo.keyword)
        
        if let mention = (try? context.fetch(request))?.first as? TweetMention {
            mention.count += 1
            return mention
        } else if let mention = NSEntityDescription.insertNewObject(forEntityName: "TweetMention", into: context) as? TweetMention {
            mention.keyWord = twitterInfo.keyword
            mention.count = 1
        }
        return nil
    }

}
