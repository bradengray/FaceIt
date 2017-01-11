//
//  TweetData+CoreDataClass.swift
//  SmashTag
//
//  Created by Braden Gray on 11/26/16.
//  Copyright © 2016 Graycode. All rights reserved.
//

import Foundation
import CoreData
import Twitter

@objc(TweetData)
public class TweetData: NSManagedObject {
    class func tweetWithTwitterInfo(twitterInfo: Tweet, inManagedObjectContext context: NSManagedObjectContext) -> TweetData? {
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "TweetData")
        request.predicate = NSPredicate(format: "unique = %@", twitterInfo.id)
        
        if let tweet = (try? context.fetch(request))?.first as? TweetData {
            return tweet
        } else if let tweet = NSEntityDescription.insertNewObject(forEntityName: "TweetData", into: context) as? TweetData {
            tweet.unique = twitterInfo.id
            tweet.text = twitterInfo.text
            tweet.posted = twitterInfo.created as NSDate?
            tweet.tweeter = TwitterUser.twitterUserWithTwitterInfo(twitterInfo: twitterInfo.user, inManagedObjectContext: context)
            var mentions: [TweetMention] = []
            let allMentions = twitterInfo.userMentions + twitterInfo.hashtags
            for mention in allMentions {
                if let tweetMention = TweetMention.mentionWithTwitterInfo(twitterInfo: mention, inManagedObjectContext: context) {
                    mentions.append(tweetMention)
                }
            }
            tweet.addToMentions(NSSet(array: mentions))
            return tweet
        }
        
        return nil
    }
}
