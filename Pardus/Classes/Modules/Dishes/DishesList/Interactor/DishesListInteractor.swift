//
//  DishesListInteractor.swift
//  Pardus
//
//  Created by Igor Postoev on 2.6.24.
//  
//


import Foundation

final class DishesListInteractor: DishesListInteractorProtocol {
    
    let modelService: EntityModelServiceType

    var dishes: [DishModel] = []
    
    var dishModels: [DishViewModel] {
        dishes.map { DishViewModel(model: $0) }
    }
    
    init(modelService: EntityModelServiceType) {
        self.modelService = modelService
    }
    
    func loadDishes() async throws {
        dishes = try await modelService.fetch(predicate: NSPredicate(value: true))
    }
    
    func deleteDishes(indexSet: IndexSet) async throws {
        try await modelService.delete(models: indexSet.map { dishes[$0] })
    }
    
    func stashState() {
        modelService.stash(view: .dishList)
    }
}

// MARK: Private
extension DishesListInteractor {
    
}
