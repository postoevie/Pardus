//
//  DishCategoryEditInteractor.swift
//  Pardus
//
//  Created by Igor Postoev on 22.7.24.
//  
//

import Foundation

protocol CategoryEntityType: IdentifiedManagedObject {
    
    var name: String { get set }
    var colorHex: String? { get set }
}

final class CategoryEditInteractor<Category: CategoryEntityType>: CategoryEditInteractorProtocol {
    
    private var category: Category?
    
    private let coreDataService: CoreDataService
    private let categoryId: UUID?
    
    init(coreDataService: CoreDataService, categoryId: UUID?) {
        self.coreDataService = coreDataService
        self.categoryId = categoryId
    }
    
    var categoryName: String? {
        get async {
            var name: String?
            await coreDataService.perform { _ in
                name = self.category?.name
            }
            return name
        }
    }
    
    var categoryColorHex: String? {
        get async {
            var colorHex: String?
            await coreDataService.perform { _ in
                colorHex = self.category?.colorHex
            }
            return colorHex
        }
    }
    
    func loadCategory() async throws {
        try await coreDataService.perform {
            if let categoryId = self.categoryId {
                self.category = try $0.fetchOne(type: Category.self,
                                                predicate: NSPredicate.idIn(uids: [categoryId]))
                return
            }
            self.category = try $0.create(type: Category.self, id: UUID())
            self.category?.name = "New category"
        }
    }
    
    func save() async throws {
        try await coreDataService.perform {
            try $0.persistChanges()
        }
    }
    
    func performWithCategory(_ action: (Category?) -> Void) {
        action(self.category)
    }
    
    func set(categoryName: String) async {
        await coreDataService.perform { _ in
            self.category?.name = categoryName
        }
    }
    
    func set(categoryColorHex: String) async {
        await coreDataService.perform { _ in
            self.category?.colorHex = categoryColorHex
        }
    }
}

// MARK: Private
extension CategoryEditInteractor {
    
}
