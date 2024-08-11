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
        do {
            try performAndWait {
                try self.save()
                if let parent {
                    try parent.persist()
                }
            }
        } catch let error as NSError where error.userInfo["NSValidationErrorObject"] != nil {
            rollback()
            throw error
        } catch {
            throw error
        }
    }
}
