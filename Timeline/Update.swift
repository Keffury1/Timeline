//
//  Update.swift
//  Timeline
//
//  Created by Bobby Keffury on 3/29/20.
//  Copyright © 2020 Bobby Keffury. All rights reserved.
//

import Foundation
import CoreData

public class Update: NSObject, NSCoding {
    
    var date: Date
    var update: String
    
    enum Key: String {
        case date = "date"
        case update = "update"
    }
    
    init(date: Date, update: String) {
        self.date = date
        self.update = update
    }
    
    public func encode(with coder: NSCoder) {
        coder.encode(date, forKey: Key.date.rawValue)
        coder.encode(update, forKey: Key.update.rawValue)
    }
    
    public required convenience init?(coder: NSCoder) {
        let date = coder.decodeObject(forKey: Key.date.rawValue)
        let update = coder.decodeObject(forKey: Key.update.rawValue)
        
        self.init(date: date as! Date, update: update as! String)
    }
}
