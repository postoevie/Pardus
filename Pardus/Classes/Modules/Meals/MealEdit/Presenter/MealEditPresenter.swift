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
    
    func editDishesTapped() {
        guard let meal = interactor.meal else {
            assertionFailure("No entity")
            return
        }
        Task {
            try await valueSubmitted()
            await MainActor.run {
                router.showDishesPick(mealId: meal.id, preselectedDishes: meal.dishes.map { $0.id }) { selectedDishes in
                    self.router.returnBack()
                    Task {
                        try await self.interactor.setSelectedDishes(selectedDishes)
                        await MainActor.run {
                            self.updateViewState()
                        }
                    }
                }
            }
        }
    }
    
    func remove(dishId: UUID) {
        Task {
            try await interactor.remove(dishId: dishId)
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
        
    }
    
    private func valueSubmitted() async throws {
        guard let viewState,
              let meal = interactor.meal else {
            assertionFailure("Prerequsites not accomplished")
            return
        }
        try await interactor.update(model: MealModel(id: meal.id, date: viewState.date, dishes: meal.dishes))
    }
    
    private func updateViewState() {
        guard let viewState else {
            return
        }
        let meal = interactor.meal
        if let meal {
            viewState.error = nil
            viewState.date = meal.date
            viewState.dishItems = meal.dishes.map { DishesListItem(model: $0) }
        } else {
            viewState.dishItems = []
            viewState.error = "No entity"
        }
    }
}
