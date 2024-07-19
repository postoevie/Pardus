//
//  MealEditInteractor.swift
//  Pardus
//
//  Created by Igor Postoev on 18.5.24.
//
//


import Foundation

@globalActor actor StorageActor: GlobalActor {
    static let shared = StorageActor()
}

actor MealEditInteractor: MealEditInteractorProtocol {
    
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
    
    func update(model: MealModel) async throws {
        try await modelService.update(models: [model])
        meal = try await modelService.fetch(entityIds: [model.id]).first
    }
    
    func save() async throws {
        try await modelService.save()
    }
    
    func setSelectedDishes(_ dishesIds: [UUID]) async throws {
        guard let meal else {
            return
        }
        lastSelectedDishesIds = dishesIds
        try await update(model: MealModel(id: meal.id,
                                          date: meal.date,
                                          dishes: try await modelService.fetch(entityIds: dishesIds)))
    }
}

// MARK: Private
extension MealEditInteractor {
    
}
