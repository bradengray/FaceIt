//
//  TweetMention+CoreDataProperties.swift
//  SmashTag
//
//  Created by Braden Gray on 11/28/16.
//  Copyright © 2016 Graycode. All rights reserved.
//

import Foundation
import CoreData


extension TweetMention {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TweetMention> {
        return NSFetchRequest<TweetMention>(entityName: "TweetMention");
    }

    @NSManaged public var keyWord: String?
    @NSManaged public var count: Int64
    @NSManaged public var tweets: NSSet?

}

// MARK: Generated accessors for tweets
extension TweetMention {

    @objc(addTweetsObject:)
    @NSManaged public func addToTweets(_ value: TweetData)

    @objc(removeTweetsObject:)
    @NSManaged public func removeFromTweets(_ value: TweetData)

    @objc(addTweets:)
    @NSManaged public func addToTweets(_ values: NSSet)

    @objc(removeTweets:)
    @NSManaged public func removeFromTweets(_ values: NSSet)

}
