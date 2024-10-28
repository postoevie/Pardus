//
//  Meal.swift
//  Pardus
//
//  Created by Igor Postoev on 19.5.24..
//

import CoreData

@objc(Meal)
class Meal: IdentifiedManagedObject {
    
    @NSManaged var date: Date
    @NSManaged var dishes: Set<MealDish>
}
