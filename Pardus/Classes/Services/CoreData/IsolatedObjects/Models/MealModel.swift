//
//  MealModel.swift
//  Pardus
//
//  Created by Igor Postoev on 27.5.24..
//

import CoreData


struct MealModel: EntityModelType, Identifiable {
    
    static private(set) var mapping: EntityModelMappingType = MealModelMapping()
    
    let id: UUID
    let date: Date
    let dishes: [DishModel]
    
    init(id: UUID, date: Date, dishes: [DishModel]) {
        self.id = id
        self.date = date
        self.dishes = dishes
    }
}

private struct MealModelMapping: EntityModelMappingType {
    
    func createObject(context: NSManagedObjectContext, model: EntityModelType) throws -> EntityModelType {
        guard let model = model as? MealModel else {
            throw NSError()
        }
        let entity = Meal(context: context)
        entity.id = model.id
        try fill(managedObject: entity, with: model)
        return try createModel(managedObject: entity)
    }
    
    func createModel(managedObject: NSManagedObject) throws -> EntityModelType {
        guard let context = managedObject.managedObjectContext,
              let entity = managedObject as? Meal else {
            throw NSError()
        }
        var model: MealModel?
        try context.performAndWait {
            model = MealModel(id: entity.id,
                              date: entity.date,
                              dishes: try entity.dishes.map {
                guard let dish = $0 as? Dish else {
                    throw NSError()
                }
                return try DishModel.mapping.createModel(managedObject: dish) as! DishModel
            })
        }
        guard let model else {
            throw NSError()
        }
        return model
    }
    
    func fill(managedObject: NSManagedObject, with model: EntityModelType) throws {
        guard let entity = managedObject as? Meal,
              let model = model as? MealModel,
              let context = managedObject.managedObjectContext else {
            throw NSError()
        }
        entity.date = model.date
        entity.dishes = NSSet(array: try model.dishes.map { dish in
            guard let objectId = dish.objectId,
                  let dish = context.object(with: objectId) as? Dish else {
                throw NSError()
            }
            return dish
        })
    }
    
    func getMOName() throws -> String {
        guard let name = Meal.entity().name else {
            throw NSError()
        }
        return name
    }
}
