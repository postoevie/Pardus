//
//  MealEditInteractor.swift
//  Pardus
//
//  Created by Igor Postoev on 18.5.24.
//
//


import Foundation

class MealDishEditInteractor: MealDishEditInteractorProtocol {
    
    var mealDishId: UUID?
    
    private var mealDish: MealDish?
    
    private let dataService: CoreDataServiceType
    
    var ingridientsFilter: Predicate? {
        guard let ingridients = mealDish?.ingridients else {
            return nil
        }
        return .idNotIn(uids: ingridients.map { $0.ingridient.id })
    }
    
    init(dataService: CoreDataServiceType, mealDishId: UUID?) {
        self.dataService = dataService
        self.mealDishId = mealDishId
    }
    
    func loadInitialMealDish() async throws {
        guard mealDish == nil else {
            return
        }
        try await dataService.perform {
            if let dishId = self.mealDishId {
                self.mealDish = try $0.fetchOne(type: MealDish.self, predicate: .idIn(uids: [dishId]))
                return
            }
            assertionFailure()
        }
    }
    
    func setSelectedIngridients(_ ingridientIds: Set<UUID>) async throws {
        guard let mealDish else {
            return
        }
        try await dataService.perform {
            let ingridientsToAdd = try $0.fetchMany(type: Ingridient.self, predicate: NSPredicate.idIn(uids: Array(ingridientIds)))
            for ingridient in ingridientsToAdd {
                let mealIngridient = try $0.create(type: MealIngridient.self, id: UUID())
                mealIngridient.dish = mealDish
                mealIngridient.ingridient = ingridient
            }
        }
    }
    
    func remove(ingridientId: UUID) async throws {
        guard let mealDish else {
            assertionFailure()
            return
        }
        await dataService.perform { _ in
            if let ingridientToRemove = mealDish.ingridients?[ingridientId] {
                self.mealDish?.ingridients?.remove(ingridientToRemove)
            }
        }
    }
    
    func performWithMealDish(action: @escaping (MealDish?) -> Void) async throws {
        await dataService.perform { _ in
            action(self.mealDish)
        }
    }
    
    func performWithIngridient(uid: UUID, action: @escaping (MealIngridient?) -> Void) async throws {
        await dataService.perform { _ in
            let ingridient = self.mealDish?.ingridients?[uid]
            action(ingridient)
        }
    }
    
    func save() async throws {
        try await dataService.perform {
            try $0.persistChanges()
        }
    }
}

