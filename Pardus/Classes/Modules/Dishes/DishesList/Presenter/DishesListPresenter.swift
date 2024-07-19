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
            try await interactor.deleteDishes(indexSet: indexSet)
            try await interactor.loadDishes()
            await MainActor.run {
                viewState?.set(items: interactor.dishModels)
            }
        }
    }
    
    func tap(at indexPath: IndexPath) {
        //wip
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
