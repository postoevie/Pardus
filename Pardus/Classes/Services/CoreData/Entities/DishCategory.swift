//
//  DishCategory.swift
//  Pardus
//
//  Created by Igor Postoev on 1.6.24..
//

import CoreData

@objc(DishCategory)
class DishCategory: IdentifiedManagedObject {
    
    @NSManaged var name: String
}