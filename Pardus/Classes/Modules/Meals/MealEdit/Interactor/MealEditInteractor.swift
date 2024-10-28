//
//  MealEditInteractor.swift
//  Pardus
//
//  Created by Igor Postoev on 18.5.24.
//
//


import Foundation

class MealEditInteractor: MealEditInteractorProtocol {
    
    var meal: Meal?
    private var lastSelectedDishesIds = [UUID]()
    
    private let dataService: CoreDataServiceType
    private var mealId: UUID?
    
    init(dataService: CoreDataServiceType, mealId: UUID?) {
        self.dataService = dataService
        self.mealId = mealId
    }
    
    func loadInitialMeal() async throws {
        guard meal == nil else {
            return
        }
        try await dataService.perform {
            if let mealId = self.mealId {
                self.meal = try $0.fetchOne(type: Meal.self, predicate: .idIn(uids: [mealId]))
                return
            }
            let newMeal = try $0.create(type: Meal.self, id: UUID())
            newMeal.date = Date()
            newMeal.dishes = Set<MealDish>()
            self.meal = newMeal
        }
    }
    
    func remove(dishId: UUID) async throws {
        guard let meal else {
            assertionFailure()
            return
        }
        try await dataService.perform {
            if let mealDish = meal.dishes[dishId] {
                try $0.delete(objectId: mealDish.objectID)
            }
        }
    }
    
    func performWithMeal(action: @escaping (Meal?) -> Void) async throws {
        await dataService.perform { _ in
            action(self.meal)
        }
    }
    
    func updateMealDish(dishId: UUID, action: @escaping (MealDish?) -> Void) async throws {
        await dataService.perform { _ in
            let mealDish = self.meal?.dishes[dishId]
            action(mealDish)
        }
    }
    
    func save() async throws {
        try await dataService.perform {
            try $0.persistChanges()
        }
    }
    
    func setSelectedDishes(_ dishesIds: Set<UUID>) async throws {
        guard let meal else {
            return
        }
        try await dataService.perform {
            let mealDishesToDelete = meal.dishes.filter { !dishesIds.contains($0.dish.id) }
            for mealDish in mealDishesToDelete {
                try $0.delete(objectId: mealDish.objectID)
            }
            let existingMealDishesIds = meal.dishes.map { $0.dish.id }
            let dishesIdsToAdd = Array(dishesIds.subtracting(existingMealDishesIds))
            let dishesToAdd = try $0.fetchMany(type: Dish.self, predicate: NSPredicate.idIn(uids: dishesIdsToAdd))
            for dish in dishesToAdd {
                let mealDish = try $0.create(type: MealDish.self, id: UUID())
                mealDish.dish = dish
                mealDish.meal = meal
                mealDish.weight = 0
            }
        }
    }
}

// MARK: Private
extension MealEditInteractor {
    
}

extension Set where Element : Identifiable<UUID> {
    
    subscript(id: UUID) -> Element? {
        self.first { $0.id == id }
    }
}
