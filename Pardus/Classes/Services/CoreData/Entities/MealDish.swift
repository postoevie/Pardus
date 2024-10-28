//
//  MealDish.swift
//  Pardus
//
//  Created by Igor Postoev on 13.8.24..
//

import CoreData

@objc(MealDish)
class MealDish: IdentifiedManagedObject {
    
    @NSManaged var meal: Meal
    @NSManaged var dish: Dish
    @NSManaged var weight: Double
}

