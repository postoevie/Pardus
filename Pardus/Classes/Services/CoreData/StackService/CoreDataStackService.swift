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
        makeFirstLaunchData(in: stack.mainQueueContext)
    }
    
    func getMainQueueContext() -> NSManagedObjectContext {
        dataStack.mainQueueContext
    }
    
    func makeChildMainQueueContext() -> NSManagedObjectContext {
        dataStack.makeStubMainQueueContext()
    }
    
    private func makeFirstLaunchData(in context: NSManagedObjectContext) {
        guard UserDefaults.standard.string(forKey: "com.pardus.firstStartupData") == nil else {
            return
        }
        
        let dishCategory = DishCategory(context: context)
        dishCategory.name = "Salads"
        dishCategory.colorHex = "#00AA00"
        dishCategory.id = UUID()
        
        let dish = Dish(context: context)
        dish.id = UUID()
        dish.name = "Carrot salad 🥕"
        dish.category = dishCategory
        
        let soup = Dish(context: context)
        soup.id = UUID()
        soup.name = "Soup 🍜"
        soup.category = dishCategory
        
        let meal = Meal(context: context)
        meal.id = UUID()
        meal.date = Date()
        meal.dishes = Set()
    
        let mealDish = MealDish(context: context)
        mealDish.id = UUID()
        
        let soupMealDish = MealDish(context: context)
        soupMealDish.id = UUID()
        
        mealDish.meal = meal
        mealDish.dish = dish
        
        soupMealDish.meal = meal
        soupMealDish.dish = soup
        
        let meal2 = Meal(context: context)
        meal2.id = UUID()
        meal2.date = Calendar.current.date(byAdding: .day,
                                           value: 1,
                                           to: Date()) ?? Date()
        meal2.dishes = Set()
        
        let meal3 = Meal(context: context)
        meal3.id = UUID()
        meal3.date = Date()
        meal3.dishes = Set()
        
        try? context.save()
        
        UserDefaults.standard.setValue(Date().formatted(), forKey: "com.pardus.firstStartupData")
    }
}
