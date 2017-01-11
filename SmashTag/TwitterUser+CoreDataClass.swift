//
//  TwitterUser+CoreDataClass.swift
//  SmashTag
//
//  Created by Braden Gray on 11/26/16.
//  Copyright © 2016 Graycode. All rights reserved.
//

import Foundation
import CoreData
import Twitter

@objc(TwitterUser)
public class TwitterUser: NSManagedObject {

    class func twitterUserWithTwitterInfo(twitterInfo: User, inManagedObjectContext context: NSManagedObjectContext) -> TwitterUser? {
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "TwitterUser")
        request.predicate = NSPredicate(format: "screenName = %@", twitterInfo.screenName)
        
        if let twitterUser = (try? context.fetch(request))?.first as? TwitterUser {
            return twitterUser
        } else if let twitterUser = NSEntityDescription.insertNewObject(forEntityName: "TwitterUser", into: context) as? TwitterUser {
            twitterUser.screenName = twitterInfo.screenName
            twitterUser.name = twitterInfo.name
            return twitterUser
        }
        
        return nil
    }

}
