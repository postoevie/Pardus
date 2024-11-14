//
//  MealIngridient.swift
//  Pardus
//
//  Created by Igor Postoev on 29.10.24..
//

import CoreData

@objc(MealIngridient)
class MealIngridient: IdentifiedManagedObject {
    
    @NSManaged var dish: MealDish
    @NSManaged var ingridient: Ingridient
    @NSManaged var weight: Double
    
    var calories: Double {
        ingridient.calories * weight / 100
    }
    
    var proteins: Double {
        ingridient.proteins * weight / 100
    }
    
    var fats: Double {
        ingridient.fats * weight / 100
    }
    
    var carbs: Double {
        ingridient.carbs * weight / 100
    }
}

