//
//  Update+Convenience.swift
//  Timeline
//
//  Created by Bobby Keffury on 3/30/20.
//  Copyright © 2020 Bobby Keffury. All rights reserved.
//

import Foundation
import CoreData

extension Update {
    convenience init(date: Date, update: String, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.date = date
        self.update = update
    }
}
