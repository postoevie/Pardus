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
    let category: DishCategoryModel
    
    let objectId: NSManagedObjectID
}

struct DishModelMapping: EntityModelMappingType {
    
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
        guard let entity = managedObject as? Dish else {
            throw NSError()
        }
        return DishModel(id: entity.id,
                         name: entity.name,
                         category: try DishCategoryModel.mapping.createModel(managedObject: entity.category) as! DishCategoryModel,
                         objectId: entity.objectID)
    }
    
    func fill(managedObject: NSManagedObject, with model: EntityModelType) throws {
        guard let entity = managedObject as? Dish,
              let model = model as? DishModel,
              let context = managedObject.managedObjectContext else {
            throw NSError()
        }
        entity.name = model.name
        entity.category = context.object(with: model.category.objectId) as! DishCategory
    }
    
    func getMOName() throws -> String {
        guard let name = Dish.entity().name else {
            throw NSError()
        }
        return name
    }
}

