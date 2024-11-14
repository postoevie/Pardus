//
//  DishesListPresenter.swift
//  Pardus
//
//  Created by Igor Postoev on 2.6.24.
//  
//

import SwiftUI

final class SearchListPresenter<Entity,
                                Interactor: SearchListInteractorProtocol>: ObservableObject, SearchListPresenterProtocol where Interactor.Entity == Entity {
    
    private let router: SearchListRouterProtocol
    private weak var viewState: SearchListViewStateProtocol?
    private let interactor: Interactor
    private let entityToListItemMapper: (Entity) -> SearchListItem
    
    init(router: SearchListRouterProtocol,
         viewState: SearchListViewStateProtocol,
         interactor: Interactor,
         entityToListItemMapper: @escaping (Entity) -> SearchListItem) {
        self.router = router
        self.viewState = viewState
        self.interactor = interactor
        self.entityToListItemMapper = entityToListItemMapper
    }
    
    func tapCategories() {
        router.showCategories()
    }
    
    func tapNewEntity() {
        router.showAddEntity()
    }
    
    func tapEditEntity(entityId: UUID) {
        router.showEditEntity(entityId: entityId)
    }
    
    func delete(entityId: UUID) {
        Task {
            do {
                try await interactor.deleteEntity(entityId: entityId)
                await reloadList()
            } catch {
                print(error) // TODO: Make error handling (P-3)
            }
        }
    }
    
    func didAppear() {
        Task {
            do {
                try await interactor.loadEntities()
                await reloadList()
            } catch {
                print(error) // TODO: Make error handling (P-3)
            }
        }
    }
    
    func setSearchText(_ text: String) {
        Task {
            interactor.setFilterText(text)
            await reloadList()
        }
    }
    
    private func reloadList() async {
        await interactor.performWithFilteredEntities { entities in
            let items = entities.map(self.entityToListItemMapper)
            DispatchQueue.main.async {
                self.viewState?.set(items: items)
            }
        }
    }
}
