//
//  IngridientEditPresenter.swift
//  Pardus
//
//  Created by Igor Postoev on 2.6.24.
//
//

import SwiftUI

final class IngridientEditPresenter: ObservableObject, IngridientEditPresenterProtocol {
    
    private let router: IngridientEditRouterProtocol
    private weak var viewState: IngridientEditViewStateProtocol?
    private let interactor: IngridientEditInteractorProtocol
    
    init(router: IngridientEditRouterProtocol,
         interactor: IngridientEditInteractorProtocol,
         viewState: IngridientEditViewStateProtocol) {
        self.router = router
        self.interactor = interactor
        self.viewState = viewState
    }
    
    func tapEditCategory() {
        guard let ingridientId = interactor.ingridientId else {
            return
        }
        Task {
            try await valueSubmitted()
            let filter = self.interactor.categoryFilter
            await MainActor.run {
                router.showPicklist(ingridientId: ingridientId, filter: filter) { [weak self ] selected in
                    guard let self else {
                        return
                    }
                    self.router.hideLast()
                    Task {
                        try await self.interactor.updateIngridientWith(categoryId: selected.first )
                        try await self.interactor.loadIngridient()
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
            try await interactor.loadIngridient()
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
        viewState.calories = data.calories
        viewState.proteins = data.proteins
        viewState.carbohydrates = data.carbohydrates
        viewState.fats = data.fats
        if let category = interactor.ingridientCategory {
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
        try await interactor.update(data: IngridientEditData(name: viewState.name,
                                                             calories: viewState.calories,
                                                             proteins: viewState.proteins,
                                                             fats: viewState.fats,
                                                             carbohydrates: viewState.carbohydrates))
    }
}
