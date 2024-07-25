//
//  DishCategoriesPicklistInteractor.swift
//  Pardus
//
//  Created by Igor Postoev on 25.7.24..
//

import Foundation

final class DishCategoriesPicklistInteractor: PicklistInteractorProtocol {
    
    private var dishCategories: [DishCategoryModel] = []
    
    private let modelService: EntityModelServiceType
    
    init(modelService: EntityModelServiceType, preselectedCategoryIds: Set<UUID>) {
        self.modelService = modelService
        self.selectedItemIds = preselectedCategoryIds
    }
    
    //MARK: -PicklistInteractorProtocol
    var items: [PicklistDataItem] {
        dishCategories.map { .dishCategory($0) }
    }
    
    var selectedItemIds: Set<UUID>
    
    func setSelected(itemId: UUID) {
        if selectedItemIds.contains(itemId) {
            selectedItemIds = Set()
            return
        }
        if let first = dishCategories.first(where: { $0.id == itemId }) {
            selectedItemIds = Set([first.id])
        }
    }
    
    func loadItems() async throws {
        dishCategories = try await modelService.fetch(predicate: NSPredicate(value: true))
    }
}

