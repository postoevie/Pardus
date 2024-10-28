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
    
    private let dataService: CoreDataServiceType
    private var _meals: [Meal] = []
    
    init(dataService: CoreDataServiceType) {
        self.dataService = dataService
    }
    
    var meals: [Meal] {
        if dateFilterEnabled {
            _meals.filter {
                let startDateCondition = Calendar.current.compare(startDate, to: $0.date, toGranularity: .minute) == .orderedAscending
                let endDateCondition = Calendar.current.compare(endDate, to: $0.date, toGranularity: .minute) == .orderedDescending
                return startDateCondition && endDateCondition
            }
        } else {
            _meals
        }
    }
    
    func performWithMeals(action: @escaping ([Meal]) -> Void) async throws {
        await dataService.perform { _ in
            action(self.meals)
        }
    }
    
    func loadMeals() async throws {
        try await dataService.perform {
            self._meals = try $0.fetchMany(type: Meal.self,
                                           predicate: nil,
                                           sortData: ((\Meal.date).propName, false))
        }
    }
    
    func delete(itemId: UUID) async throws {
        guard let index = _meals.firstIndex(where: { $0.id == itemId }) else {
            assertionFailure("Entity with passed id should be in DB")
            return
        }
        let mealToDelete = _meals.remove(at: index)
        try await dataService.perform {
            try $0.delete(objectId: mealToDelete.objectID)
            try $0.persistChanges()
        }
    }
}

// MARK: Private
extension MealsListInteractor {
    
}
