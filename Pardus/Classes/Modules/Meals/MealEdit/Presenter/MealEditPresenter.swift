//
//  MealEditPresenter.swift
//  Pardus
//
//  Created by Igor Postoev on 18.5.24.
//  
//

import SwiftUI
import Combine

final class MealEditPresenter: MealEditPresenterProtocol {
  
    private let router: MealEditRouterProtocol
    private weak var viewState: MealEditViewState?
    private let interactor: MealEditInteractorProtocol
    
    var subscriptions = [AnyCancellable]()
    
    init(router: MealEditRouterProtocol,
         interactor: MealEditInteractorProtocol,
         viewState: MealEditViewState) {
        self.router = router
        self.interactor = interactor
        self.viewState = viewState
    }
    
    func didAppear() {
        Task {
            try await interactor.loadInitialMeal()
            await MainActor.run {
                self.updateViewState()
            }
        }
    }
    
    func editTapped() {
        Task {
            guard let meal = await interactor.meal else {
                return
            }
            await MainActor.run {
                router.showDishesPick(preselectedDishes: meal.dishes.map { $0.id }) { selectedDishes in
                    self.router.returnBack()
                    Task {
                        try await self.interactor.setSelectedDishes(Array(selectedDishes)) //TODO: Fix on meal editing task
                        await MainActor.run {
                            self.updateViewState()
                        }
                    }
                }
            }
        }
    }
    
    func updateViewState() {
        guard let viewState else {
            return
        }
        Task {
            let meal = await self.interactor.meal
            await MainActor.run {
                if let meal {
                    viewState.error = nil
                    viewState.date = meal.date
                    viewState.dishes = meal.dishes.map { $0.name }
                } else {
                    viewState.dishes = []
                    viewState.error = "No entity"
                }
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
    
    private func valueSubmitted() async throws {
        guard let viewState,
              let meal = await self.interactor.meal else {
            return
        }
        try await interactor.update(model: MealModel(id: meal.id, date: viewState.date, dishes: meal.dishes))
    }
}
