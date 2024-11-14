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
    
    var dishId: UUID?
    
    private let coreDataService: CoreDataServiceType
    
    private var dish: Dish?
   
    init(coreDataService: CoreDataServiceType, dishId: UUID?) {
        self.coreDataService = coreDataService
        self.dishId = dishId
    }
    
    var categoriesFilter: Predicate? {
        guard let categoryId = dish?.category?.id else {
            return nil
        }
        return .idNotIn(uids: [categoryId])
    }
    
    var ingridientsFilter: Predicate? {
        guard let ingridients = dish?.ingridients else {
            return nil
        }
        return .idNotIn(uids: ingridients.map { $0.id })
    }
    
    func loadInitialDish() async throws {
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
    
    func performWithDish(action: @escaping (Dish?) -> Void) async throws {
        await coreDataService.perform { _ in
            action(self.dish)
        }
    }
    
    func setCategory(uid: UUID?) async throws {
        guard let dish else {
            assertionFailure()
            return
        }
        try await coreDataService.perform {
            if let uid {
                dish.category = try $0.fetchOne(type: DishCategory.self, predicate: .idIn(uids: [uid]))
            } else {
                dish.category = nil
            }
        }
    }
    
    func setSelectedIngridients(uids: Set<UUID>) async throws {
        guard let dish else {
            assertionFailure()
            return
        }
        try await coreDataService.perform {
            let selectedIngridients = Set(try $0.fetchMany(type: Ingridient.self, predicate: NSPredicate.idIn(uids: Array(uids))))
            dish.ingridients = if let ingridients = dish.ingridients {
                ingridients.union(selectedIngridients)
            } else {
                selectedIngridients
            }
        }
    }
    
    func remove(ingridientId: UUID) async throws {
        guard let dish else {
            assertionFailure()
            return
        }
        await coreDataService.perform { _ in
            if let ingridient = dish.ingridients?[ingridientId] {
                dish.ingridients?.remove(ingridient)
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
