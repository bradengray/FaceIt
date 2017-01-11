//
//  TweetData+CoreDataProperties.swift
//  SmashTag
//
//  Created by Braden Gray on 11/28/16.
//  Copyright © 2016 Graycode. All rights reserved.
//

import Foundation
import CoreData


extension TweetData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TweetData> {
        return NSFetchRequest<TweetData>(entityName: "TweetData");
    }

    @NSManaged public var posted: NSDate?
    @NSManaged public var text: String?
    @NSManaged public var unique: String?
    @NSManaged public var tweeter: TwitterUser?
    @NSManaged public var mentions: NSSet?

}

// MARK: Generated accessors for mentions
extension TweetData {

    @objc(addMentionsObject:)
    @NSManaged public func addToMentions(_ value: TweetMention)

    @objc(removeMentionsObject:)
    @NSManaged public func removeFromMentions(_ value: TweetMention)

    @objc(addMentions:)
    @NSManaged public func addToMentions(_ values: NSSet)

    @objc(removeMentions:)
    @NSManaged public func removeFromMentions(_ values: NSSet)

}
