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
    
    func tapAddNew() {
        interactor.stashState()
        router.showAdd()
    }
    
    func delete(indexSet: IndexSet) {
        Task {
            do {
                try await interactor.deleteDishes(indexSet: indexSet)
                try await interactor.loadDishes()
            } catch {
                print(error) // TODO: Make error handling (P-3)
            }
            await MainActor.run {
                viewState?.set(items: interactor.dishModels)
            }
        }
    }
    
    func tapDish(_ dish: DishViewModel) {
        router.showEdit(dishId: dish.id)
    }
    
    func didAppear() {
        Task {
            try await interactor.loadDishes()
            await MainActor.run {
                viewState?.set(items: interactor.dishModels)
            }
        }
    }
}
