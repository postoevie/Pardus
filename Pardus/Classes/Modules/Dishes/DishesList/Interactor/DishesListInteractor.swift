//
//  DishesListInteractor.swift
//  Pardus
//
//  Created by Igor Postoev on 2.6.24.
//  
//


import Foundation

final class DishesListInteractor: DishesListInteractorProtocol {
    
    var filteredDishes: [DishModel] = []

    var dishes: [DishModel] = []
    
    let modelService: EntityModelServiceType
    
    init(modelService: EntityModelServiceType) {
        self.modelService = modelService
    }
    
    func loadDishes() async throws {
        dishes = try await modelService.fetch(predicate: NSPredicate(value: true))
        filteredDishes = dishes
    }
    
    func deleteDish(dishId: UUID) async throws {
        guard let dishToDelete = dishes.first(where: { $0.id == dishId }) else {
            assertionFailure()
            return
        }
        try await modelService.delete(models: [dishToDelete])
        try await modelService.save()
    }
    
    func stashState() {
        modelService.stash(view: .dishList)
    }
    
    func setFilterText(_ text: String) {
        filteredDishes = dishes.filter { $0.name.hasPrefix(text) }
    }
}

// MARK: Private
extension DishesListInteractor {
    
}
