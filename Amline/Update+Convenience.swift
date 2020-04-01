//
//  Update+Convenience.swift
//  Timeline
//
//  Created by Bobby Keffury on 3/30/20.
//  Copyright © 2020 Bobby Keffury. All rights reserved.
//

import Foundation
import UIKit
import CoreData

extension Update {
    convenience init(title: String, date: Date, update: String, image: NSObject?, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.title = title
        self.date = date
        self.update = update
        self.image = image as? UIImage
    }
}
