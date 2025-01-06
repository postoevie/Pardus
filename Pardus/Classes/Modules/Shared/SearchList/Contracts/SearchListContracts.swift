//
//  SearchListContracts.swift
//  Pardus
//
//  Created by Igor Postoev on 2.6.24.
//  
//

import SwiftUI
import CoreData

// Router
protocol SearchListRouterProtocol: RouterProtocol {

    func showAddEntity()
    func showEditEntity(entityId: UUID)
    func showCategories()
    func showError(messageKey: String)
}

// Presenter
protocol SearchListPresenterProtocol: ObservableObject, PresenterProtocol {

    func didAppear()
    func tapCategories()
    func tapNewEntity()
    func tapEditEntity(entityId: UUID)
    func delete(entityId: UUID)
    func setSearchText(_ text: String)
}

protocol SearchListPresenterCustomizerProtocol {
    
    associatedtype Entity
    
    var navigationTitle: LocalizedStringKey { get }
    func mapToItem(entity: Entity) -> SearchListItem
}

// Interactor
protocol SearchListInteractorProtocol: InteractorProtocol {
    
    associatedtype Entity: SearchListEntityType

    func loadEntities() async throws
    func performWithFilteredEntities(action: @escaping ([Entity]) -> Void) async
    func deleteEntity(entityId: UUID) async throws
    func setFilterText(_ text: String)
}

// ViewState
protocol SearchListViewStateProtocol: ViewStateProtocol {
    
    func set(items: [SearchListItem])
    func setNavigationTitle(key: LocalizedStringKey)
}

protocol SearchListEntityType: IdentifiedManagedObject {
    
    var name: String { get set }
}
