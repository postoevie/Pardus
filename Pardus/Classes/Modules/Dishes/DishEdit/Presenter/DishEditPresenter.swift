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
    
    func tapEditCategory() {
        Task {
            try await valueSubmitted()
            await MainActor.run {
                let preselected: [UUID] = if let category = interactor.dishCategory {
                    [category.id]
                } else {
                    []
                }
                router.showPicklist(preselectedCategories: Set(preselected)) { [weak self ] selected in
                    guard let self else {
                        return
                    }
                    self.router.hideLast()
                    Task {
                        try await self.interactor.updateDishWith(categoryId: selected.first )
                        try await self.interactor.loadDish()
                        await MainActor.run {
                            self.updateViewState()
                        }
                    }
                }
            }
        }
    }
    
    func didAppear() {
        Task {
            try await interactor.loadDish()
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
    
    func navigateBackTapped() {
        router.returnBack()
    }
    
    private func updateViewState() {
        guard let viewState else {
            return
        }
        guard let data = interactor.data else {
            viewState.name = ""
            viewState.error = "No entity"
            return
        }
        viewState.name = data.name
        if let category = interactor.dishCategory {
            viewState.category = category
        } else {
            viewState.category = nil
        }
        viewState.error = nil
    }
    
    private func valueSubmitted() async throws {
        guard let viewState else {
            return
        }
        try await interactor.update(data: DishEditData(name: viewState.name,
                                                       calories: viewState.calories,
                                                       proteins: viewState.proteins,
                                                       fats: viewState.fats,
                                                       carbohydrates: viewState.carbohydrates))
    }
}
