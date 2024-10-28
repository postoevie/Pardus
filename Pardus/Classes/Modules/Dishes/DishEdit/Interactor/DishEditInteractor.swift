//
//  DishEditInteractor.swift
//  Pardus
//
//  Created by Igor Postoev on 2.6.24.
//  
//


import Foundation
import CoreData
import SwiftUI

final class DishEditInteractor: DishEditInteractorProtocol {
    
    private var dish: Dish?
    private var dishId: UUID?
    private let coreDataService: CoreDataServiceType
    
    init(coreDataService: CoreDataServiceType, dishId: UUID?) {
        self.coreDataService = coreDataService
        self.dishId = dishId
    }
    
    var data: DishEditData? {
        guard let dish else {
            return nil
        }
        return DishEditData(name: dish.name,
                            calories: dish.calories,
                            proteins: dish.proteins,
                            fats: dish.fats,
                            carbohydrates: dish.carbs)
    }
    
    var dishCategory: DishCategoryViewModel? {
        guard let dishCategory = dish?.category else {
            return nil
        }
        return DishCategoryViewModel(id: dishCategory.id,
                                     name: dishCategory.name,
                                     color: try? UIColor(hex: dishCategory.colorHex))
    }
    
    func update(data: DishEditData) async throws {
        await coreDataService.perform { _ in
            guard let dish = self.dish else {
                assertionFailure()
                return
            }
            dish.name = data.name
            dish.calories = data.calories
            dish.proteins = data.proteins
            dish.fats = data.fats
            dish.carbs = data.carbohydrates
        }
    }

    func loadDish() async throws {
        if let dishId {
            try await coreDataService.perform {
                self.dish = try $0.fetchOne(type: Dish.self, predicate: .idIn(uids: [dishId]))
            }
            return
        }
        try await coreDataService.perform {
            let newDish = try $0.create(type: Dish.self, id: UUID())
            self.dish = newDish
            self.dishId = newDish.id
        }
    }
    
    func updateDishWith(categoryId: UUID?) async throws {
        guard let dish else {
            assertionFailure()
            return
        }
        
        try await coreDataService.perform {
            if let categoryId {
                dish.category = try $0.fetchOne(type: DishCategory.self, predicate: .idIn(uids: [categoryId]))
            } else {
                dish.category = nil
            }
        }
    }
    
    func save() async throws {
        try await coreDataService.perform {
            try $0.persistChanges()
        }
    }
}

// MARK: Private
extension DishEditInteractor {
    
}
