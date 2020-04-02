//
//  Timeline+CoreDataProperties.swift
//  Timeline
//
//  Created by Bobby Keffury on 3/31/20.
//  Copyright © 2020 Bobby Keffury. All rights reserved.
//
//

import Foundation
import CoreData


extension Timeline {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Timeline> {
        return NSFetchRequest<Timeline>(entityName: "Timeline")
    }

    @NSManaged public var color: NSObject
    @NSManaged public var title: String
    @NSManaged public var updates: NSSet

}

// MARK: Generated accessors for updates
extension Timeline {

    @objc(addUpdatesObject:)
    @NSManaged public func addToUpdates(_ value: Update)

    @objc(removeUpdatesObject:)
    @NSManaged public func removeFromUpdates(_ value: Update)

    @objc(addUpdates:)
    @NSManaged public func addToUpdates(_ values: NSSet)

    @objc(removeUpdates:)
    @NSManaged public func removeFromUpdates(_ values: NSSet)

}
