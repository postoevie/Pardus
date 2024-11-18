//
//  MealEditInteractor.swift
//  Pardus
//
//  Created by Igor Postoev on 18.5.24.
//
//


import Foundation

class MealEditInteractor: MealEditInteractorProtocol {
    
    var mealId: UUID?
    
    private var meal: Meal?
    
    private let coreDataService: CoreDataServiceType
    
    var dishesFilter: Predicate? {
        var dishesIds = [UUID]()
        coreDataService.syncPerform { _ in
            guard let dishes = meal?.dishes else {
                return
            }
            dishesIds = dishes.map { $0.dish.id }
        }
        
        return .idNotIn(uids: dishesIds)
    }
    
    init(coreDataService: CoreDataServiceType, mealId: UUID?) {
        self.coreDataService = coreDataService
        self.mealId = mealId
    }
    
    func loadInitialMeal() async throws {
        guard meal == nil else {
            return
        }
        try await coreDataService.perform {
            if let mealId = self.mealId {
                self.meal = try $0.fetchOne(type: Meal.self, predicate: .idIn(uids: [mealId]))
                return
            }
            let newMeal = try $0.create(type: Meal.self, id: UUID())
            newMeal.date = Date()
            newMeal.dishes = Set<MealDish>()
            self.mealId = newMeal.id
            self.meal = newMeal
        }
    }
    
    func remove(dishId: UUID) async throws {
        guard let meal else {
            assertionFailure()
            return
        }
        try await coreDataService.perform {
            if let mealDish = meal.dishes[dishId] {
                try $0.delete(objectId: mealDish.objectID)
            }
        }
    }
    
    func performWithMeal(action: @escaping (Meal?) -> Void) async throws {
        await coreDataService.perform { _ in
            action(self.meal)
        }
    }
    
    func updateMealDish(uid: UUID, action: @escaping (MealDish?) -> Void) async throws {
        await coreDataService.perform { _ in
            let mealDish = self.meal?.dishes[uid]
            action(mealDish)
        }
    }
    
    func save() async throws {
        try await coreDataService.perform {
            try $0.persistChanges()
        }
    }
    
    func setSelectedDishes(_ dishesIds: Set<UUID>) async throws {
        guard let meal else {
            return
        }
        try await coreDataService.perform {
            let dishesToAdd = try $0.fetchMany(type: Dish.self, predicate: NSPredicate.idIn(uids: Array(dishesIds)))
            for dish in dishesToAdd {
                let mealDish = try $0.create(type: MealDish.self, id: UUID())
                mealDish.dish = dish
                mealDish.meal = meal
                
                let ingridientsToAdd = dish.ingridients ?? []
                for ingridient in ingridientsToAdd {
                    let mealIngridient = try $0.create(type: MealIngridient.self, id: UUID())
                    mealIngridient.dish = mealDish
                    mealIngridient.ingridient = ingridient
                }
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
