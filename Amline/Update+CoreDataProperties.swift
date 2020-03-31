//
//  Update+CoreDataProperties.swift
//  Timeline
//
//  Created by Bobby Keffury on 3/31/20.
//  Copyright © 2020 Bobby Keffury. All rights reserved.
//
//

import Foundation
import CoreData


extension Update {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Update> {
        return NSFetchRequest<Update>(entityName: "Update")
    }

    @NSManaged public var date: Date?
    @NSManaged public var update: String?
    @NSManaged public var timeline: Timeline?

}
