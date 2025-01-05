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
    private var meals: [Meal] = []
    
    init(dataService: CoreDataServiceType) {
        self.dataService = dataService
    }
    
    private var filteredMeals: [Meal] {
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
    
    func loadMeals() async throws {
        try await dataService.perform {
            self.meals = try $0.fetchMany(type: Meal.self,
                                          predicate: nil,
                                          sortBy: SortParams(fieldName: (\Meal.date).fieldName, ascending: false))
        }
    }
    
    func performWithMeals(action: @escaping ([Meal]) -> Void) async throws {
        await dataService.perform { _ in
            action(self.filteredMeals)
        }
    }
    
    func getDishes(for meal: Meal) -> [MealDish] {
        Array(meal.dishes).sorted {
            $0.name < $1.name
        }
    }
    
    func delete(itemId: UUID) async throws {
        try await dataService.perform {
            guard let index = self.meals.firstIndex(where: { $0.id == itemId }) else {
                assertionFailure("Entity with passed id should be in DB")
                return
            }
            let mealToDelete = self.meals.remove(at: index)
            try $0.delete(objectId: mealToDelete.objectID)
            try $0.persistChanges()
        }
    }
}

// MARK: Private
extension MealsListInteractor {
    
}
