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
    
    let dataStack: CoreDataStack
    
    init(inMemory: Bool) {
        let stack = CoreDataStack()
        stack.setup(inMemory: inMemory)
        dataStack = stack
    }
    
    func getMainQueueContext() -> NSManagedObjectContext {
        dataStack.mainQueueContext
    }
    
    func makeChildMainQueueContext() -> NSManagedObjectContext {
        dataStack.makeStubMainQueueContext()
    }
}
