//
//  CoreDataStackService.swift
//  Pardus
//
//  Created by Igor Postoev on 19.5.24.
//	
//

import Foundation
import CoreData

class CoreDataStackService: CoreDataStackServiceType {
    
    let dataStack = {
        let stack = CoreDataStack()
        stack.setup()
        return stack
    }()
    
    func makeChildMainQueueContext() -> NSManagedObjectContext {
        dataStack.makeStubMainQueueContext()
    }
}
