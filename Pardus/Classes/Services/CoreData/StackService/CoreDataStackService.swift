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
        stack.setup(inMemory: false)
        return stack
    }()
    
    func getMainQueueContext() -> NSManagedObjectContext {
        dataStack.mainQueueContext
    }
    
    func makeChildMainQueueContext() -> NSManagedObjectContext {
        dataStack.makeStubMainQueueContext()
    }
}

class CoreDataStackInMemoryService: CoreDataStackServiceType {
    
    let dataStack = {
        let stack = CoreDataStack()
        stack.setup(inMemory: true)
        return stack
    }()
    
    func getMainQueueContext() -> NSManagedObjectContext {
        dataStack.mainQueueContext
    }
    
    func makeChildMainQueueContext() -> NSManagedObjectContext {
        dataStack.makeStubMainQueueContext()
    }
}
