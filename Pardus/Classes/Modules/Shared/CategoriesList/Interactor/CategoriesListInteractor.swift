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
    
    func performWithDishData(_ action: @escaping ([CategoriesListDataItem<MainEntity, DetailEntity>]) -> Void) async {
        await coreDataService.perform { _ in
            var data = [CategoriesListDataItem<MainEntity, DetailEntity>]()
            for entity in self.mainEntities {
                let item = CategoriesListDataItem(mainEntity: entity, detailEntities: self.getDetailEntities(for: entity))
                data.append(item)
            }
            let orphanDetails = self.customizer.getOrphanEntities(detailEntities: self.detailEntities)
            if !orphanDetails.isEmpty {
                data.append(CategoriesListDataItem(mainEntity: nil, detailEntities: orphanDetails))
            }
            action(data)
        }
    }
    
    func loadDishes() async throws {
        try await coreDataService.perform {
            self.mainEntities = try $0.fetchMany(type: MainEntity.self, predicate: nil)
            self.detailEntities = try $0.fetchMany(type: DetailEntity.self, predicate: nil)
        }
    }
    
    func deleteDetailEntity(entityId: UUID) async throws {
        try await coreDataService.perform {
            guard let entityIndex = self.detailEntities.firstIndex(where: { $0.id == entityId }) else {
                assertionFailure()
                return
            }
            let entityToDelete = self.detailEntities.remove(at: entityIndex)
            try $0.delete(objectId: entityToDelete.objectID)
            try $0.persistChanges()
        }
    }
    
    func deleteMainEntity(entityId: UUID) async throws {
        try await coreDataService.perform {
            guard let entityIndex = self.mainEntities.firstIndex(where: { $0.id == entityId }) else {
                assertionFailure()
                return
            }
            let entityToDelete = self.mainEntities.remove(at: entityIndex)
            let detailIdsToDelete = self.getDetailEntities(for: entityToDelete).map { $0.id }
            self.detailEntities = self.detailEntities.filter { !detailIdsToDelete.contains($0.id) }
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
