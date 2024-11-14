//
//  IngridientEditInteractor.swift
//  Pardus
//
//  Created by Igor Postoev on 2.6.24.
//  
//


import Foundation
import CoreData
import SwiftUI

final class IngridientEditInteractor: IngridientEditInteractorProtocol {
    
    var ingridientId: UUID?
    
    private var ingridient: Ingridient?
    private let coreDataService: CoreDataServiceType
    
    init(coreDataService: CoreDataServiceType, ingridientId: UUID?) {
        self.coreDataService = coreDataService
        self.ingridientId = ingridientId
    }
    
    var categoryFilter: Predicate? {
        guard let categoryId = ingridient?.category?.id else {
            return nil
        }
        return .idNotIn(uids: [categoryId])
    }
    
    var ingridientCategory: IngridientCategoryViewModel? {
        guard let category = ingridient?.category,
              let colorHex = category.colorHex else {
            return nil
        }
        return IngridientCategoryViewModel(id: category.id,
                                           name: category.name,
                                           color: try? UIColor(hex: colorHex))
    }
    
    var data: IngridientEditData? {
        guard let ingridient else {
            return nil
        }
        return IngridientEditData(name: ingridient.name,
                                  calories: ingridient.calories,
                                  proteins: ingridient.proteins,
                                  fats: ingridient.fats,
                                  carbohydrates: ingridient.carbs)
    }
    
    func update(data: IngridientEditData) async throws {
        await coreDataService.perform { _ in
            guard let ingridient = self.ingridient else {
                assertionFailure()
                return
            }
            ingridient.name = data.name
            ingridient.calories = data.calories
            ingridient.proteins = data.proteins
            ingridient.fats = data.fats
            ingridient.carbs = data.carbohydrates
        }
    }
    
    func updateDishWith(categoryId: UUID?) async throws {
        guard let ingridient else {
            assertionFailure()
            return
        }
        
        try await coreDataService.perform {
            if let categoryId {
                ingridient.category = try $0.fetchOne(type: IngridientCategory.self, predicate: .idIn(uids: [categoryId]))
            } else {
                ingridient.category = nil
            }
        }
    }

    func loadIngridient() async throws {
        if let ingridientId {
            try await coreDataService.perform {
                self.ingridient = try $0.fetchOne(type: Ingridient.self, predicate: .idIn(uids: [ingridientId]))
            }
            return
        }
        try await coreDataService.perform {
            let newIngridient = try $0.create(type: Ingridient.self, id: UUID())
            self.ingridient = newIngridient
            self.ingridientId = newIngridient.id
        }
    }
    
    func updateIngridientWith(categoryId: UUID?) async throws {
        guard let ingridient else {
            assertionFailure()
            return
        }
        try await coreDataService.perform {
            if let categoryId {
                ingridient.category = try $0.fetchOne(type: IngridientCategory.self, predicate: .idIn(uids: [categoryId]))
            } else {
                ingridient.category = nil
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
extension IngridientEditInteractor {
    
}
