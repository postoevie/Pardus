//
//  DishesPickInteractor.swift
//  Pardus
//
//  Created by Igor Postoev on 10.6.24.
//  
//


import Foundation

final class DishesPickInteractor: DishesPickInteractorProtocol {
    
    var dishModels: [DishModel] = []
    var selectedDishModels: [DishModel] = []
    
    private let modelService: EntityModelServiceType
    private let preselectedDishesIds: [UUID]
    
    init(modelService: EntityModelServiceType, preselectedDishesIds: [UUID]) {
        self.modelService = modelService
        self.preselectedDishesIds = preselectedDishesIds
    }
    
    func loadDishes() async throws {
        dishModels = try await modelService.fetch(predicate: NSPredicate(value: true))
        selectedDishModels = dishModels.filter { preselectedDishesIds.contains($0.id) }
    }
    
    func setSelectedModels(dish: DishPickViewModel) {
        if let index = selectedDishModels.firstIndex(where: { $0.id == dish.id }) {
            selectedDishModels.remove(at: index)
        } else if let first = dishModels.first(where: { $0.id == dish.id }) {
            selectedDishModels.append(first)
        }
    }
}

// MARK: Private
extension DishesPickInteractor {
    
}
