//
//  DishGroupModel.swift
//  Pardus
//
//  Created by Igor Postoev on 1.6.24..
//

import CoreData

struct DishCategoryModel: EntityModelType {
    
    private(set) static var mapping: EntityModelMappingType = DishCategoryModelMapping()
    
    let id: UUID
    let name: String
    
    let objectId: NSManagedObjectID
}

struct DishCategoryModelMapping: EntityModelMappingType {
    
    func createObject(context: NSManagedObjectContext, model: EntityModelType) throws -> EntityModelType {
        guard let model = model as? DishCategoryModel else {
            throw NSError()
        }
        let entity = DishCategory(context: context)
        entity.id = model.id
        try fill(managedObject: entity, with: model)
        return try createModel(managedObject: entity)
    }
    
    func createModel(managedObject: NSManagedObject) throws -> EntityModelType {
        guard let entity = managedObject as? DishCategory else {
            throw NSError()
        }
        return DishCategoryModel(id: entity.id, name: entity.name, objectId: entity.objectID)
    }
    
    func fill(managedObject: NSManagedObject, with model: EntityModelType) throws {
        guard let entity = managedObject as? DishCategory,
              let model = model as? DishCategoryModel else {
            throw NSError()
        }
        entity.name = model.name
    }
    
    func getMOName() throws -> String {
        guard let name = DishCategory.entity().name else {
            throw NSError()
        }
        return name
    }
}