//
//  DishesPickInteractor.swift
//  Pardus
//
//  Created by Igor Postoev on 10.6.24.
//  
//


import Foundation

final class DishesPicklistInteractor: PicklistInteractorProtocol {
   
    private var dishModels: [DishModel] = []
    
    private let modelService: EntityModelServiceType
    
    init(modelService: EntityModelServiceType, preselectedDishesIds: Set<UUID>) {
        self.modelService = modelService
        self.selectedItemIds = preselectedDishesIds
    }
    
    //MARK: -PicklistInteractorProtocol
    var items: [PicklistDataItem] {
        dishModels.map { .dish($0) }
    }
    
    var selectedItemIds: Set<UUID>
    
    func setSelected(itemId: UUID) {
        selectedItemIds.remove(itemId)
        if let first = dishModels.first(where: { $0.id == itemId }) {
            selectedItemIds.insert(first.id)
        }
    }
    
    func loadItems() async throws {
        dishModels = try await modelService.fetch(predicate: NSPredicate(value: true))
    }
}
