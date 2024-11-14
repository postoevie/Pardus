//
//  DishesListInteractor.swift
//  Pardus
//
//  Created by Igor Postoev on 2.6.24.
//  
//

protocol SearchListEntityType: IdentifiedManagedObject {
    
    var name: String { get set }
}

import Foundation

final class SearchListInteractor<Entity: SearchListEntityType>: SearchListInteractorProtocol {
    
    var filteredEnties: [Entity] {
        guard !filterText.isEmpty else {
            return entities
        }
        return entities.filter {
            $0.name.contains(filterText)
        }
    }
    
    var filterText = ""

    var entities: [Entity] = []
    
    let coreDataService: CoreDataServiceType
    
    init(coreDataService: CoreDataServiceType) {
        self.coreDataService = coreDataService
    }
    
    func loadEntities() async throws {
        try await coreDataService.perform {
            self.entities = try $0.fetchMany(type: Entity.self, predicate: nil)
        }
    }
    
    func performWithFilteredEntities(action: @escaping ([Entity]) -> Void) async {
        await coreDataService.perform { _ in
            action(self.filteredEnties)
        }
    }
    
    func deleteEntity(entityId: UUID) async throws {
        guard let entityIndexToDelete = entities.firstIndex(where: { $0.id == entityId }) else {
            assertionFailure()
            return
        }
        let entityToDelete = entities.remove(at: entityIndexToDelete)
        try await coreDataService.perform {
            try $0.delete(objectId: entityToDelete.objectID)
            try $0.persistChanges()
        }
    }
    
    func setFilterText(_ text: String) {
        filterText = text
    }
}

// MARK: Private
extension SearchListInteractor {
    
}
