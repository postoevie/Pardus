//
//  DishesListPresenter.swift
//  Pardus
//
//  Created by Igor Postoev on 2.6.24.
//  
//

import SwiftUI

final class DishesListPresenter: ObservableObject, DishesListPresenterProtocol {
   
    private let router: DishesListRouterProtocol
    private weak var viewState: DishesListViewStateProtocol?
    private let interactor: DishesListInteractorProtocol
    
    init(router: DishesListRouterProtocol,
         interactor: DishesListInteractorProtocol,
         viewState: DishesListViewStateProtocol) {
        self.router = router
        self.interactor = interactor
        self.viewState = viewState
    }
    
    func tapGroup() {
        router.showSections()
    }
    
    func tapNewDish() {
        interactor.stashState()
        router.showAddDish()
    }
    
    func tapEditDish(dishId: UUID) {
        router.showEditDish(dishId: dishId)
    }
    
    func delete(dishId: UUID) {
        Task {
            do {
                try await interactor.deleteDish(dishId: dishId)
                try await interactor.loadDishes()
            } catch {
                print(error) // TODO: Make error handling (P-3)
            }
            await MainActor.run {
                reloadList()
            }
        }
    }
    
    func didAppear() {
        Task {
            do {
                try await interactor.loadDishes()
            } catch {
                print(error) // TODO: Make error handling (P-3)
            }
            await MainActor.run {
                reloadList()
            }
        }
    }
    
    func reloadList() {
        viewState?.set(dishesList: interactor.filteredDishes.map { DishViewModel(model: $0) })
    }
    
    func setSearchText(_ text: String) {
        interactor.setFilterText(text)
        reloadList()
    }
}
