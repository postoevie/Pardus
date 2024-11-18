//
//  DishCategoriesPicklistInteractor.swift
//  Pardus
//
//  Created by Igor Postoev on 25.7.24..
//

import SwiftUI

enum PicklistType {
    
    case singular
    case multiple
}

final class PicklistInteractor<Entity: PicklistItemEntityType>: PicklistInteractorProtocol {
    
    var selectedItemIds = Set<UUID>()
    
    private var entities: [Entity] = []
    private let coreDataService: CoreDataServiceType
    private let type: PicklistType
    private let filterPredicate: Predicate?
    
    init(coreDataService: CoreDataService, type: PicklistType, filterPredicate: Predicate?) {
        self.coreDataService = coreDataService
        self.type = type
        self.filterPredicate = filterPredicate
    }
    
    //MARK: -PicklistInteractorProtocol
    var items: [PicklistViewItem] {
        entities.map { entity in
            let color: UIColor =
            if let colorHex = entity.indicatorColorHex,
               let color = try? UIColor(hex: colorHex) {
                color
            } else {
                .clear
            }
            return PicklistViewItem(id: entity.id,
                                    isSelected: selectedItemIds.contains(entity.id),
                                    type: .onlyTitle(title: entity.picklistItemTitle,
                                                     indicatorColor: color))
        }
    }
    
    func setSelected(itemId: UUID) {
        switch type {
        case.singular:
            setWithSingularType(itemId: itemId)
        case .multiple:
            setWithMultipleType(itemId: itemId)
        }
    }
    
    private func setWithSingularType(itemId: UUID) {
        selectedItemIds = [itemId]
    }
    
    private func setWithMultipleType(itemId: UUID) {
        if selectedItemIds .contains(itemId) {
            selectedItemIds.remove(itemId)
            return
        }
        selectedItemIds = selectedItemIds.union([itemId])
    }
    
    func loadItems() async throws {
        try await coreDataService.perform {
            self.entities = try $0.fetchMany(type: Entity.self, predicate: try NSPredicate.map(predicate: self.filterPredicate))
        }
    }
}

