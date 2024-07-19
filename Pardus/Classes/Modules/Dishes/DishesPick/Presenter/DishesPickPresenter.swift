//
//  DishesPickPresenter.swift
//  Pardus
//
//  Created by Igor Postoev on 10.6.24.
//  
//

import SwiftUI
import Combine

final class DishesPickPresenter: ObservableObject, DishesPickPresenterProtocol {
    
    weak var viewState: DishesPicklistStateProtocol?
    
    private let router: DishesPickRouterProtocol
    private let interactor: DishesPickInteractorProtocol
    private let completion: ([UUID]) -> Void
    
    init(router: DishesPickRouterProtocol,
         interactor: DishesPickInteractorProtocol,
         completion: @escaping ([UUID]) -> Void) {
        self.router = router
        self.interactor = interactor
        self.completion = completion
    }
    
    func didAppear() {
        Task {
            try await interactor.loadDishes()
            await MainActor.run {
                viewState?.dishes = interactor.dishModels.map { DishPickViewModel(model: $0) }
                viewState?.selectedDishes = Set(interactor.selectedDishModels.map { DishPickViewModel(model: $0) })
            }
        }
    }
    
    func doneTapped() {
        completion(interactor.selectedDishModels.map { $0.id })
    }
    
    func getSelectedDishes() -> Set<DishPickViewModel> {
        Set(interactor.selectedDishModels.map { DishPickViewModel(model: $0) })
    }
    
    func setSelected(dish: DishPickViewModel) {
        interactor.setSelectedModels(dish: dish)
        viewState?.selectedDishes = getSelectedDishes()
    }
}
