//
//  CategoriesListInteractor.swift
//  Pardus
//
//  Created by Igor Postoev on 23.7.24.
//  
//

import Foundation

final class CategoriesListInteractor<MainEntity: IdentifiedManagedObject,
                                         DetailEntity: IdentifiedManagedObject,
                                         Customizer: CategoriesListInteractorCustomizerProtocol>: CategoriesListInteractorProtocol where Customizer.MainEntity == MainEntity, Customizer.DetailEntity == DetailEntity {
    
    private var mainEntities: [MainEntity] = []
    private var detailEntities: [DetailEntity] = []
    private let coreDataService: CoreDataServiceType
    private let customizer: Customizer
    
    init(coreDataService: CoreDataServiceType,
         customizer: Customizer){
        self.coreDataService = coreDataService
        self.customizer = customizer
    }
    
    func performWithDishData(_ action: ([CategoriesListDataItem<MainEntity, DetailEntity>]) -> Void) async {
        var data = [CategoriesListDataItem<MainEntity, DetailEntity>]()
        for entity in mainEntities {
            let item = CategoriesListDataItem(mainEntity: entity, detailEntities: getDetailEntities(for: entity))
            data.append(item)
        }
        let orphanDetails = customizer.getOrphanEntities(detailEntities: detailEntities)
        if !orphanDetails.isEmpty {
            data.append(CategoriesListDataItem(mainEntity: nil, detailEntities: orphanDetails))
        }
        action(data)
    }
    
    func loadDishes() async throws {
        try await coreDataService.perform {
            self.mainEntities = try $0.fetchMany(type: MainEntity.self, predicate: nil)
            self.detailEntities = try $0.fetchMany(type: DetailEntity.self, predicate: nil)
        }
    }
    
    func deleteDetailEntity(entityId: UUID) async throws {
        guard let entityIndex = detailEntities.firstIndex(where: { $0.id == entityId }) else {
            assertionFailure()
            return
        }
        let entityToDelete = detailEntities.remove(at: entityIndex)
        try await coreDataService.perform {
            try $0.delete(objectId: entityToDelete.objectID)
            try $0.persistChanges()
        }
    }
    
    func deleteMainEntity(entityId: UUID) async throws {
        guard let entityIndex = mainEntities.firstIndex(where: { $0.id == entityId }) else {
            assertionFailure()
            return
        }
        let entityToDelete = mainEntities.remove(at: entityIndex)
        let detailIdsToDelete = getDetailEntities(for: entityToDelete).map { $0.id }
        detailEntities = detailEntities.filter { !detailIdsToDelete.contains($0.id) }
        try await coreDataService.perform {
            try $0.delete(objectId: entityToDelete.objectID)
            try $0.persistChanges()
        }
    }
    
}

// MARK: Private
extension CategoriesListInteractor {
    
    fileprivate func getDetailEntities(for mainEntity: MainEntity) -> [DetailEntity] {
        customizer.getDetailEntities(mainEntity: mainEntity)
    }
}
