//
//  NSManagedObjectContext.swift
//  Pardus
//
//  Created by Igor Postoev on 19.5.24..
//

import CoreData

extension NSManagedObjectContext {
    
    func persist() throws {
        guard hasChanges else {
            return
        }
        try performAndWait {
            try self.save()
            if let parent {
                try parent.persist()
            }
        }
    }
}
