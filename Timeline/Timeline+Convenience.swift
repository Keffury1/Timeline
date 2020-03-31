//
//  Timeline+Convenience.swift
//  Timeline
//
//  Created by Bobby Keffury on 3/30/20.
//  Copyright © 2020 Bobby Keffury. All rights reserved.
//

import Foundation
import CoreData

extension Timeline {
    convenience init(color: String, title: String, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.color = color
        self.title = title
    }
}
