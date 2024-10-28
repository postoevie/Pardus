//
//  DishModel.swift
//  Pardus
//
//  Created by Igor Postoev on 31.5.24..
//

import CoreData

struct DishModel: EntityModelType, Identifiable {
    
    private(set) static var mapping: EntityModelMappingType = DishModelMapping()
    
    let id: UUID
    let name: String
    let category: DishCategoryModel?
    let calories: Double
    let proteins: Double
    let fats: Double
    let carbohydrates: Double
    
    let objectId: NSManagedObjectID?
}

private struct DishModelMapping: EntityModelMappingType {
    
    func createObject(context: NSManagedObjectContext, model: EntityModelType) throws -> EntityModelType {
        guard let model = model as? DishModel else {
            throw NSError()
        }
        let entity = Dish(context: context)
        entity.id = model.id
        try fill(managedObject: entity, with: model)
        return try createModel(managedObject: entity)
    }
    
    func createModel(managedObject: NSManagedObject) throws -> EntityModelType {
        guard let context = managedObject.managedObjectContext,
              let entity = managedObject as? Dish else {
            throw NSError()
        }
        var dishModel: DishModel?
        try context.performAndWait {
            var category: DishCategoryModel?
            if let entityCategory = entity.category {
                category = try DishCategoryModel.mapping.createModel(managedObject: entityCategory) as? DishCategoryModel
            }
            dishModel = DishModel(id: entity.id,
                                  name: entity.name,
                                  category: category,
                                  calories: entity.calories,
                                  proteins: entity.proteins,
                                  fats: entity.fats,
                                  carbohydrates: entity.carbs,
                                  objectId: entity.objectID)
        }
        guard let dishModel else {
            throw NSError()
        }
        return dishModel
    }
    
    func fill(managedObject: NSManagedObject, with model: EntityModelType) throws {
        guard let entity = managedObject as? Dish,
              let model = model as? DishModel,
              let context = managedObject.managedObjectContext else {
            throw NSError()
        }
        entity.name = model.name
        entity.calories = model.calories
        entity.proteins = model.proteins
        entity.fats = model.fats
        entity.carbs = model.carbohydrates
        entity.category = if let categoryId = model.category?.objectId {
            context.object(with: categoryId) as? DishCategory
        } else {
            nil
        }
    }
    
    func getMOName() throws -> String {
        guard let name = Dish.entity().name else {
            throw NSError()
        }
        return name
    }
}

