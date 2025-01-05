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
        var categoryId: UUID?
        coreDataService.syncPerform { _ in
            categoryId = dish?.category?.id
        }
        guard let categoryId else {
            return nil
        }
        return .idNotIn(uids: [categoryId])
    }
    
    var ingridientsFilter: Predicate? {
        var ingridientIds = [UUID]()
        coreDataService.syncPerform { _ in
            guard let ingridients = self.dish?.ingridients else {
                return
            }
            ingridientIds = ingridients.map { $0.id }
        }
        return .idNotIn(uids: ingridientIds)
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
    
    func performWithIngridients(action: @escaping ([Ingridient]) -> Void) async {
        await coreDataService.perform { _ in
            guard let ingridients = self.dish?.ingridients else {
                action([])
                return
            }
            action(self.sorted(ingridients: Array(ingridients)))
        }
    }
    
    private func sorted(ingridients: [Ingridient]) -> [Ingridient] {
        ingridients.sorted {
            $0.name < $1.name
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
            dish.ingridients = dish.ingridients.union(selectedIngridients)
        }
    }
    
    func remove(ingridientId: UUID) async throws {
        guard let dish else {
            assertionFailure()
            return
        }
        await coreDataService.perform { _ in
            if let ingridient = dish.ingridients[ingridientId] {
                dish.ingridients.remove(ingridient)
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
