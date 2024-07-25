//
//  DishEditInteractor.swift
//  Pardus
//
//  Created by Igor Postoev on 2.6.24.
//  
//


import Foundation
import CoreData

final class DishEditInteractor: DishEditInteractorProtocol {
 
    private(set) var dish: DishModel?
    
    private let modelService: EntityModelServiceType
    private var dishId: UUID?
    
    init(modelService: EntityModelServiceType, dishId: UUID?) {
        self.modelService = modelService
        self.dishId = dishId
    }
    
    func loadDish() async throws {
        if let dishId {
            dish = try await modelService.fetch(entityIds: [dishId]).first
            return
        }
        dish = try await modelService.create(model: DishModel(id: UUID(),
                                                              name: "",
                                                              category: nil,
                                                              objectId: nil))
        dishId = dish?.id
    }
    
    func update(model: DishModel) async throws {
        try await modelService.update(models: [model])
        dish = try await modelService.fetch(entityIds: [model.id]).first
    }
    
    func updateDishWith(categoryId: UUID?) async throws {
        guard let dish else {
            assertionFailure()
            return
        }
        var dishCategory: DishCategoryModel? = nil
        if let categoryId {
            let categories: [DishCategoryModel] = try await modelService.fetch(entityIds: [categoryId])
            dishCategory = categories.first
        }
        try await modelService.update(models: [DishModel(id: dish.id,
                                                         name: dish.name,
                                                         category: dishCategory,
                                                         objectId: dish.objectId)])
    }
    
    func save() async throws {
        try await modelService.save()
    }
}

// MARK: Private
extension DishEditInteractor {
    
}
