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
    
    private let coreDataService: CoreDataServiceType
    
    var ingridientsFilter: Predicate? {
        var ingridientIds = [UUID]()
        coreDataService.syncPerform { _ in
            guard let ingridients = self.mealDish?.ingridients else {
                return
            }
            ingridientIds = ingridients.map { $0.ingridient.id }
        }
        return .idNotIn(uids: ingridientIds)
    }
    
    init(coreDataService: CoreDataServiceType, mealDishId: UUID?) {
        self.coreDataService = coreDataService
        self.mealDishId = mealDishId
    }
    
    func loadInitialMealDish() async throws {
        guard mealDish == nil,
              let mealDishId else {
            assertionFailure()
            return
        }
        try await coreDataService.perform { executor in
            self.mealDish = try executor.fetchOne(type: MealDish.self, predicate: .idIn(uids: [mealDishId]))
        }
    }
    
    func setSelectedIngridients(_ ingridientIds: Set<UUID>) async throws {
        guard let mealDish else {
            return
        }
        try await coreDataService.perform {
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
        await coreDataService.perform { _ in
            if let ingridientToRemove = mealDish.ingridients?[ingridientId] {
                self.mealDish?.ingridients?.remove(ingridientToRemove)
            }
        }
    }
    
    func performWithMealDish(action: @escaping (MealDish?) -> Void) async throws {
        await coreDataService.perform { _ in
            action(self.mealDish)
        }
    }
    
    func performWithIngridient(uid: UUID, action: @escaping (MealIngridient?) -> Void) async throws {
        await coreDataService.perform { _ in
            let ingridient = self.mealDish?.ingridients?[uid]
            action(ingridient)
        }
    }
    
    func save() async throws {
        try await coreDataService.perform {
            try $0.persistChanges()
        }
    }
}

