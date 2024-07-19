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
    
    func loadInitialDish() async throws {
        if let dishId {
            dish = try await modelService.fetch(entityIds: [dishId]).first
            return
        }
        let category: DishCategoryModel? =
        if let first: DishCategoryModel = try await modelService.fetch(predicate: NSPredicate(value: true)).first {
            first
        } else {
            nil
        }
        dish = try await modelService.create(model: DishModel(id: UUID(),
                                                              name: "",
                                                              category: category,
                                                              objectId: nil))
    }
    
    func update(model: DishModel) async throws {
        try await modelService.update(models: [model])
        dish = try await modelService.fetch(entityIds: [model.id]).first
    }
    
    func save() async throws {
        try await modelService.save()
    }
}

// MARK: Private
extension DishEditInteractor {
    
}
