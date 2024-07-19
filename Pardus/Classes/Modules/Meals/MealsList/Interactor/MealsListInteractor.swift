//
//  MealsListInteractor.swift
//  Pardus
//
//  Created by Igor Postoev on 18.5.24.
//  
//


import Foundation

final class MealsListInteractor: MealsListInteractorProtocol {
    
    let modelService: EntityModelServiceType

    var meals: [MealModel] = []
    
    var mealModels: [MealModel] {
        meals
    }
    
    init(modelService: EntityModelServiceType) {
        self.modelService = modelService
    }
    
    func loadMeals() async throws {
        meals = try await modelService.fetch(predicate: nil, sortParams: ((\Meal.date).propName, false))
    }
    
    func deleteMeals(indexSet: IndexSet) async throws {
        try await modelService.delete(models: indexSet.map { meals[$0] })
        try await modelService.save()
    }
    
    func stashState() {
        modelService.stash(view: .mealsList)
    }
}

// MARK: Private
extension MealsListInteractor {
    
}
