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
    
    func setup() {
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
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Unable to load persistent stores: \(error)")
            }
        }
    }
    
    private func makeModel() -> NSManagedObjectModel {
        var mealDescription = {
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
        
        var dishDescription = {
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
            
            desc.properties = [idAttr, nameAttr]
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
        dishToCatRel.isOptional = true
    
        // how obnject erases
        dishDescription.properties.append(dishToCatRel)

        let model = NSManagedObjectModel()
        model.entities = [mealDescription,
                          dishDescription,
                          dishCategoryDescription]
        return model
    }
}
