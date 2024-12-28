//
//  DishesListInteractor.swift
//  Pardus
//
//  Created by Igor Postoev on 2.6.24.
//  
//

import CoreData

final class SearchListInteractor<Entity: SearchListEntityType>: SearchListInteractorProtocol {
    
    private var filterText = ""
    
    private var entityIds: [UUID] = []
    
    private var entitiesByIds: [UUID: Entity] = [:]

    private let coreDataService: CoreDataServiceType
    
    private let sortParams: SortParams
    
    init(coreDataService: CoreDataServiceType,
         sortParams: SortParams) {
        self.coreDataService = coreDataService
        self.sortParams = sortParams
    }
    
    private var filteredEnties: [Entity] {
        guard !filterText.isEmpty else {
            return entities
        }
        return entities.filter {
            $0.name.contains(filterText)
        }
    }
    
    private var entities: [Entity] {
        entityIds.compactMap { entitiesByIds[$0] }
    }
    
    func loadEntities() async throws {
        try await coreDataService.perform {
            let entities = try $0.fetchMany(type: Entity.self, predicate: nil, sortBy: self.sortParams)
            self.entityIds = entities.map { $0.id }
            self.entitiesByIds = Dictionary(uniqueKeysWithValues: entities.map { ($0.id, $0) })
        }
    }
    
    func performWithFilteredEntities(action: @escaping ([Entity]) -> Void) async {
        await coreDataService.perform { _ in
            action(self.filteredEnties)
        }
    }
    
    func deleteEntity(entityId: UUID) async throws {
        try await coreDataService.perform {
            guard let entityToDelete = self.entitiesByIds[entityId] else {
                assertionFailure()
                return
            }
            self.entityIds.removeAll(where: { $0 == entityId })
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
