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
    private var mealId: UUID?
    
    init(modelService: EntityModelServiceType, mealId: UUID?) {
        self.modelService = modelService
        self.mealId = mealId
    }
    
    func loadInitialDish() async throws {
        if let mealId {
            dish = try await modelService.fetch(entityIds: [mealId]).first
            return
        }
        let category: DishCategoryModel
        if let first: DishCategoryModel = try await modelService.fetch(predicate: NSPredicate(value: true)).first {
            category = first
        } else {
            category = try await modelService.create(model: DishCategoryModel(id: UUID(),
                                                                              name: "Soups",
                                                                              objectId: NSManagedObjectID()))
        }
        dish = try await modelService.create(model: DishModel(id: UUID(),
                                                              name: "",
                                                              category: category,
                                                              objectId: NSManagedObjectID()))
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
