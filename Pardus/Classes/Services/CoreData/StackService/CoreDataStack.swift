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
        context.parent = privateQueueContext
        context.automaticallyMergesChangesFromParent = true
        context.retainsRegisteredObjects = true
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        context.shouldDeleteInaccessibleFaults = true
        return context
    }
    
    func setup(inMemory: Bool) {
        let model = makeModel()
        let documentDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last
        
//        try? FileManager.default.contentsOfDirectory(atPath: documentDir!.relativePath).forEach {
//            let url = documentDir!.appending(path: $0)
//            try? FileManager.default.removeItem(at: url)
//        }
//        
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
            carbohydratesAttr.name = "carbohydrates"
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
        
        let mealToDishRel = NSRelationshipDescription()
        mealToDishRel.name = "dishes"
        mealToDishRel.isOptional = true
        mealToDishRel.destinationEntity = dishDescription
        mealToDishRel.deleteRule = .nullifyDeleteRule
        mealDescription.properties.append(mealToDishRel)
        
        let dishToMealRel = NSRelationshipDescription()
        dishToMealRel.name = "meals"
        dishToMealRel.isOptional = true
        dishToMealRel.destinationEntity = mealDescription
        dishToMealRel.deleteRule = .denyDeleteRule
        dishDescription.properties.append(dishToMealRel)
        
        mealToDishRel.inverseRelationship = dishToMealRel
        dishToMealRel.inverseRelationship = mealToDishRel
        
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

        let model = NSManagedObjectModel()
        model.entities = [mealDescription,
                          dishDescription,
                          dishCategoryDescription]
        return model
    }
}
