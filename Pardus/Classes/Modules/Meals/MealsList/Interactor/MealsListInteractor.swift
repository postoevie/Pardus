//
//  MealsListInteractor.swift
//  Pardus
//
//  Created by Igor Postoev on 18.5.24.
//  
//


import Foundation

final class MealsListInteractor: MealsListInteractorProtocol {
    
    var startDate = Date()
    
    var endDate = Date()
    
    var dateFilterEnabled: Bool = false
    
    var mealModels: [MealModel] {
        if dateFilterEnabled {
            meals.filter {
                let startDateCondition = Calendar.current.compare(startDate, to: $0.date, toGranularity: .minute) == .orderedAscending
                let endDateCondition = Calendar.current.compare(endDate, to: $0.date, toGranularity: .minute) == .orderedDescending
                return startDateCondition && endDateCondition
            }
        } else {
            meals
        }
    }
    
    private var meals: [MealModel] = []
    
    private let modelService: EntityModelServiceType
    
    init(modelService: EntityModelServiceType) {
        self.modelService = modelService
    }
    
    func loadMeals() async throws {
        meals = try await modelService.fetch(predicate: nil, sortParams: ((\Meal.date).propName, false))
    }
    
    func delete(itemId: UUID) async throws {
        guard let first = meals.first(where: { $0.id == itemId }) else {
            assertionFailure()
            return
        }
        try await modelService.delete(models: [first])
        try await modelService.save()
    }
    
    func stashState() {
        modelService.stash(view: .mealsList)
    }
}

// MARK: Private
extension MealsListInteractor {
    
}
