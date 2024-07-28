//
//  CoreDataRestorationStore.swift
//  Pardus
//
//  Created by Igor Postoev on 31.5.24.
//	
//

import Foundation

import CoreData
import Combine

struct CoreDataRestorationItem {
    
    let entityCaches: [String: any EntityCacheType]
    let context: NSManagedObjectContext
}

class MockRestorationStore: CoreDataRestorationStoreType {
    
    func restore(key: Views) -> CoreDataRestorationItem? {
        nil
    }
    
    func store(key: Views, item: CoreDataRestorationItem) {

    }
}

class CoreDataRestorationStore: CoreDataRestorationStoreType {
    
    var restorationItems: [Views: CoreDataRestorationItem] = [:]
    var subscriptions: [AnyCancellable] = []
    
    init(navigationService: any NavigationServiceType) {
        // Releases context if a view is out of scope
        navigationService.itemsPublisher
            .receive(on: DispatchQueue.main)
            .sink { items in
            print(items)
            for key in self.restorationItems.keys where !items.contains(key) {
                self.restorationItems[key] = nil
            }
        }.store(in: &subscriptions)
    }
    
    func restore(key: Views) -> CoreDataRestorationItem? {
        restorationItems[key]
    }
    
    func store(key: Views, item: CoreDataRestorationItem) {
        restorationItems[key] = item
    }
}
