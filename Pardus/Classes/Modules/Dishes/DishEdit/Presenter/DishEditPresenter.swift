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
                let preselected: [UUID] = if let category = interactor.dish?.category {
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
        if let category = dish.category {
            let color = (try? UIColor(hex: category.colorHex)) ?? .clear
            viewState.category = DishCategoryViewModel(id: category.id, name: category.name, color: color)
        }
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
