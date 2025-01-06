//
//  CategoriesListContracts.swift
//  Pardus
//
//  Created by Igor Postoev on 23.7.24.
//  
//

import SwiftUI

// Router
protocol CategoriesListRouterProtocol: RouterProtocol {

    func showAddDetail()
    func showAddCategory()
    func showEditCategory(categoryId: UUID)
    func showEditDetail(detailEntityId: UUID)
    func showSearchList()
}

// Presenter
protocol CategoriesListPresenterProtocol: ObservableObject, PresenterProtocol {

    func tapNewDetail()
    func tapNewCategory()
    func didAppear()
    func delete(categoryId: UUID)
    func tapEdit(categoryId: UUID)
    func delete(dishId: UUID)
    func tapEditDish(dishId: UUID)
    func okAlertTapped()
    func tapSearch()
}

// Interactor
protocol CategoriesListInteractorProtocol: InteractorProtocol {
    
    associatedtype MainEntity
    associatedtype DetailEntity
    
    func performWithDishData(_ action: @escaping ([CategoriesListDataItem<MainEntity, DetailEntity>]) -> Void) async
    func loadDishes() async throws
    func deleteDetailEntity(entityId: UUID) async throws
    func deleteMainEntity(entityId: UUID) async throws
}

// ViewState
protocol CategoriesListViewStateProtocol: ObservableObject, ViewStateProtocol {
    
    func setNavigationTitle(text: String)
    func set(sections: [CategoriesListSection])
    func showAlert(title: String)
    func hideAlert()
}

protocol CategoriesListPresenterCustomizerProtocol {
    
    associatedtype MainEntity
    associatedtype DetailEntity
    
    func makeListSections(data: [CategoriesListDataItem<MainEntity, DetailEntity>]) -> [CategoriesListSection]
    func getNavigationTitle() -> String
}

protocol CategoriesListInteractorCustomizerProtocol {
    
    associatedtype MainEntity
    associatedtype DetailEntity
    
    func getDetailEntities(mainEntity: MainEntity) -> [DetailEntity]
    
    func getOrphanEntities(detailEntities: [DetailEntity]) -> [DetailEntity]
}
