//
//  DishesSectionsListInteractor.swift
//  Pardus
//
//  Created by Igor Postoev on 23.7.24.
//  
//


import Foundation

final class DishesSectionsListInteractor: DishesSectionsListInteractorProtocol {

    var dishCategories: [DishCategoryModel] = []

    var dishes: [DishModel] = []
    
    let modelService: EntityModelServiceType
    
    init(modelService: EntityModelServiceType) {
        self.modelService = modelService
    }
    
    func loadDishes() async throws {
        dishes = try await modelService.fetch(predicate: NSPredicate(value: true))
        dishCategories = try await modelService.fetch(predicate: NSPredicate(value: true))
    }
    
    func deleteDish(dishId: UUID) async throws {
        guard let dishToDelete = dishes.first(where: { $0.id == dishId }) else {
            assertionFailure()
            return
        }
        try await modelService.delete(models: [dishToDelete])
        try await modelService.save()
    }
    
    func deleteDishCategory(categoryId: UUID) async throws {
        guard let categoryToDelete = dishCategories.first(where: { $0.id == categoryId }) else {
            assertionFailure()
            return
        }
        try await modelService.delete(models: [categoryToDelete])
        try await modelService.save()
    }
}

// MARK: Private
extension DishesSectionsListInteractor {
    
}
