//
//  SearchListContracts.swift
//  Pardus
//
//  Created by Igor Postoev on 2.6.24.
//  
//

import SwiftUI


// Router
protocol SearchListRouterProtocol: RouterProtocol {

    func showAddEntity()
    func showEditEntity(entityId: UUID)
    func showCategories()
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
    func setNavigationtitle(text: String)
}
