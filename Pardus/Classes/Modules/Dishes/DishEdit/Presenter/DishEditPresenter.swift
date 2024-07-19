//
//  DishEditPresenter.swift
//  Pardus
//
//  Created by Igor Postoev on 2.6.24.
//  
//

import SwiftUI

final class DishEditPresenter: ObservableObject, DishEditPresenterProtocol {
    
    private let router: DishEditRouterProtocol
    private weak var viewState: DishEditViewStateProtocol?
    private let interactor: DishEditInteractorProtocol
    
    init(router: DishEditRouterProtocol,
         interactor: DishEditInteractorProtocol,
         viewState: DishEditViewStateProtocol) {
        self.router = router
        self.interactor = interactor
        self.viewState = viewState
    }
    
    func didAppear() {
        Task {
            try await interactor.loadInitialDish()
            await MainActor.run {
                self.updateViewState()
            }
        }
    }
    
    func doneTapped() {
        Task {
            try await valueSubmitted()
            try await interactor.save()
            await MainActor.run {
                router.returnBack()
            }
        }
    }
    
    func updateViewState() {
        guard let viewState else {
            return
        }
        guard let dish = self.interactor.dish else {
            viewState.name = ""
            viewState.error = "No entity"
            return
        }
        viewState.name = dish.name
        viewState.error = nil
    }
    
    private func valueSubmitted() async throws {
        guard let viewState,
              let dish = self.interactor.dish else {
            return
        }
        try await interactor.update(model: DishModel(id: dish.id,
                                                     name: viewState.name,
                                                     category: dish.category,
                                                     objectId: dish.objectId))
    }
}
