//
//  CoreDataStackServiceType.swift
//  Pardus
//
//  Created by Igor Postoev on 19.5.24.
//	
//

import Foundation
import CoreData

protocol CoreDataStackServiceType {
    
    /// Creates child context working with main queue
    func makeChildMainQueueContext() -> NSManagedObjectContext
}
