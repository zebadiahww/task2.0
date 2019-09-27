//
//  Task+Convenience.swift
//  Task
//
//  Created by Zebadiah Watson on 9/25/19.
//  Copyright © 2019 Zebadiah Watson. All rights reserved.
//

import Foundation
import CoreData

extension Task {
    
    convenience init(name: String, notes: String, due: Date, isComplete: Bool = false, moc: NSManagedObjectContext = CoreDataStack.context) {
        
        self.init(context: moc)
        self.name = name
        self.notes = notes
        self.due = due
        self.isComplete = isComplete
    }
}
