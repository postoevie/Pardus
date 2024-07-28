//
//  MealEditInteractor.swift
//  Pardus
//
//  Created by Igor Postoev on 18.5.24.
//
//


import Foundation

class MealEditInteractor: MealEditInteractorProtocol {
    
    var meal: MealModel?
    private var lastSelectedDishesIds = [UUID]()
    
    private let modelService: EntityModelServiceType
    private var mealId: UUID?
    
    init(modelService: EntityModelServiceType, mealId: UUID?) {
        self.modelService = modelService
        self.mealId = mealId
    }
    
    func loadInitialMeal() async throws {
        guard meal == nil else {
            return
        }
        if let mealId {
            meal = try await modelService.fetch(entityIds: [mealId]).first
            return
        }
        meal = try await modelService.create(model: MealModel(id: UUID(),
                                                              date: Date(),
                                                              dishes: []))
    }
    
    func remove(dishId: UUID) async throws {
        guard let meal else {
            assertionFailure("No entity")
            return
        }
        let filteredDishes = meal.dishes.filter {
            $0.id != dishId
        }
        try await update(model: MealModel(id: meal.id,
                                          date: meal.date,
                                          dishes: filteredDishes))
    }
    
    func update(model: MealModel) async throws {
        try await modelService.update(models: [model])
        meal = try await modelService.fetch(entityIds: [model.id]).first
    }
    
    func save() async throws {
        try await modelService.save()
    }
    
    func setSelectedDishes(_ dishesIds: Set<UUID>) async throws {
        guard let meal else {
            return
        }
        try await update(model: MealModel(id: meal.id,
                                          date: meal.date,
                                          dishes: try await modelService.fetch(entityIds: Array(dishesIds))))
    }
}

// MARK: Private
extension MealEditInteractor {
    
}
