//
//  CoreDataStack.swift
//  Pardus
//
//  Created by Igor Postoev on 19.5.24..
//

import CoreData

class CoreDataStack {
    
    // You use an NSPersistentContainer instance to set up the model, context, and store coordinator simultaneously.
    var container: NSPersistentContainer!
    
    var coordinator: NSPersistentStoreCoordinator {
        container.persistentStoreCoordinator
    }
    
    lazy var mainQueueContext: NSManagedObjectContext = {
        let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        context.persistentStoreCoordinator = coordinator
        context.automaticallyMergesChangesFromParent = true
        context.retainsRegisteredObjects = true
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        context.shouldDeleteInaccessibleFaults = true
        return context
    }()
    
    lazy var privateQueueContext: NSManagedObjectContext = {
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.automaticallyMergesChangesFromParent = false
        context.persistentStoreCoordinator = coordinator
        return context
    }()
    
    func makeStubMainQueueContext() -> NSManagedObjectContext {
        let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        context.parent = mainQueueContext
        context.automaticallyMergesChangesFromParent = true
        context.retainsRegisteredObjects = true
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        context.shouldDeleteInaccessibleFaults = true
        return context
    }
    
    func setup(inMemory: Bool) {
        let model = makeModel()
        let documentDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last
        
        let url = documentDir!.appending(path: "Pardus.sqlite")
        
        //let url = URL(filePath: "/Users/igorpostoev/tmp/Pardus.sqlite")
        
        container = NSPersistentContainer(name: "Pardus", managedObjectModel: model)
        guard let description = container.persistentStoreDescriptions.first else {
            fatalError("Failed to retrieve a persistent store description.")
        }
        print("DBURL: \(url)")
        description.url = url
        description.type = inMemory ? NSInMemoryStoreType : NSSQLiteStoreType
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Unable to load persistent stores: \(error)")
            }
        }
    }
    
    private func makeModel() -> NSManagedObjectModel {
        let mealDescription = {
            let desc = NSEntityDescription()
            desc.name = "Meal"
            desc.managedObjectClassName = String(describing: Meal.self)
            
            let idAttr = NSAttributeDescription()
            idAttr.name = "id"
            idAttr.attributeType = .UUIDAttributeType
            
            let dateAttr = NSAttributeDescription()
            dateAttr.name = "date"
            dateAttr.attributeType = .dateAttributeType
            
            desc.properties = [idAttr, dateAttr]
            return desc
        }()
        
        let dishDescription = {
            let desc = NSEntityDescription()
            desc.name = "Dish"
            desc.managedObjectClassName = String(describing: Dish.self)
            
            let idAttr = NSAttributeDescription()
            idAttr.name = "id"
            idAttr.attributeType = .UUIDAttributeType
            
            let nameAttr = NSAttributeDescription()
            nameAttr.name = "name"
            nameAttr.attributeType = .stringAttributeType
            nameAttr.isOptional = true
            
            let caloriesAttr = NSAttributeDescription()
            caloriesAttr.name = "calories"
            caloriesAttr.attributeType = .doubleAttributeType
            caloriesAttr.defaultValue = 0
            
            let proteinsAttr = NSAttributeDescription()
            proteinsAttr.name = "proteins"
            proteinsAttr.attributeType = .doubleAttributeType
            proteinsAttr.defaultValue = 0
            
            let fatsAttr = NSAttributeDescription()
            fatsAttr.name = "fats"
            fatsAttr.attributeType = .doubleAttributeType
            fatsAttr.defaultValue = 0
            
            let carbohydratesAttr = NSAttributeDescription()
            carbohydratesAttr.name = "carbs"
            carbohydratesAttr.attributeType = .doubleAttributeType
            carbohydratesAttr.defaultValue = 0
            
            
            desc.properties = [idAttr,
                               nameAttr,
                               caloriesAttr,
                               proteinsAttr,
                               fatsAttr,
                               carbohydratesAttr]
            
            return desc
        }()
        
        let dishCategoryDescription = {
            let desc = NSEntityDescription()
            desc.name = "DishCategory"
            desc.managedObjectClassName = String(describing: DishCategory.self)
            
            let idAttr = NSAttributeDescription()
            idAttr.name = "id"
            idAttr.attributeType = .UUIDAttributeType
            
            let nameAttr = NSAttributeDescription()
            nameAttr.name = "name"
            nameAttr.attributeType = .stringAttributeType
            nameAttr.isOptional = true
            
            let colorAttr = NSAttributeDescription()
            colorAttr.name = "colorHex"
            colorAttr.attributeType = .stringAttributeType
            colorAttr.isOptional = true
            
            desc.properties = [idAttr, nameAttr, colorAttr]
            return desc
        }()
        
        // Dish - DishCategory relationship
        let dishToCatRel = NSRelationshipDescription()
        dishToCatRel.name = "category"
        dishToCatRel.destinationEntity = dishCategoryDescription
        dishToCatRel.maxCount = 1
        dishToCatRel.deleteRule = .nullifyDeleteRule
        dishToCatRel.isOptional = true
        
        let catToDishRel = NSRelationshipDescription()
        catToDishRel.name = "dishes"
        catToDishRel.destinationEntity = dishDescription
        catToDishRel.deleteRule = .denyDeleteRule
        catToDishRel.isOptional = true
        
        dishToCatRel.inverseRelationship = catToDishRel
        catToDishRel.inverseRelationship = dishToCatRel
    
        dishDescription.properties.append(dishToCatRel)
        dishCategoryDescription.properties.append(catToDishRel)
        
        // MealDish attributes and relationships
        let mealDishDescription = {
            let desc = NSEntityDescription()
            desc.name = "MealDish"
            desc.managedObjectClassName = String(describing: MealDish.self)
            
            let idAttr = NSAttributeDescription()
            idAttr.name = "id"
            idAttr.attributeType = .UUIDAttributeType
            
            let weightAttr = NSAttributeDescription()
            weightAttr.name = "weight"
            weightAttr.attributeType = .doubleAttributeType
            
            desc.properties = [idAttr, weightAttr]
            return desc
        }()
        
        // MealDish --> Meal
        let mealDishToMealRel = NSRelationshipDescription()
        mealDishToMealRel.name = "meal"
        mealDishToMealRel.destinationEntity = mealDescription
        mealDishToMealRel.deleteRule = .nullifyDeleteRule
        mealDishToMealRel.maxCount = 1
        mealDishToMealRel.minCount = 1
        mealDishDescription.properties.append(mealDishToMealRel)

        // Meal --> MealDish
        let mealToMealDishRel = NSRelationshipDescription()
        mealToMealDishRel.name = "dishes"
        mealToMealDishRel.isOptional = true
        mealToMealDishRel.destinationEntity = mealDishDescription
        mealToMealDishRel.deleteRule = .cascadeDeleteRule
        mealDescription.properties.append(mealToMealDishRel)
        
        mealDishToMealRel.inverseRelationship = mealToMealDishRel
        mealToMealDishRel.inverseRelationship = mealDishToMealRel
        
        // MealDish --> Dish
        let mealDishToDishRel = NSRelationshipDescription()
        mealDishToDishRel.name = "dish"
        mealDishToDishRel.destinationEntity = dishDescription
        mealDishToDishRel.deleteRule = .nullifyDeleteRule
        mealDishToDishRel.maxCount = 1
        mealDishToDishRel.minCount = 1
        mealDishDescription.properties.append(mealDishToDishRel)

        // Dish --> MealDish
        let dishToMealDishRel = NSRelationshipDescription()
        dishToMealDishRel.name = "mealDishes"
        dishToMealDishRel.isOptional = true
        dishToMealDishRel.destinationEntity = mealDishDescription
        dishToMealDishRel.deleteRule = .denyDeleteRule
        dishDescription.properties.append(dishToMealDishRel)
        
        dishToMealDishRel.inverseRelationship = mealDishToMealRel
        mealDishToMealRel.inverseRelationship = dishToMealDishRel
        
        let model = NSManagedObjectModel()
        model.entities = [mealDescription,
                          dishDescription,
                          dishCategoryDescription,
                          mealDishDescription]
        return model
    }
}
