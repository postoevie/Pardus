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
            try await interactor.performWithDish { dish in
                self.updateViewState(dish: dish)
            }
        }
    }
    
    func editCategoryTapped() {
        guard let dishId = interactor.dishId else {
            return
        }
        Task {
            try await valueSubmitted()
            let predicate = self.interactor.categoriesFilter
            await MainActor.run {
                router.showCategoriesPicklist(dishId: dishId, filter: predicate) { [weak self] selected in
                    guard let self else {
                        return
                    }
                    self.router.hideLast()
                    Task {
                        try await self.interactor.setCategory(uid: selected.first )
                        try await self.interactor.performWithDish { dish in
                            self.updateViewState(dish: dish)
                        }
                    }
                }
            }
        }
    }
    
    func createIngridientTapped() {
        guard let dishId = interactor.dishId else {
            return
        }
        Task {
            try await valueSubmitted()
            let predicate = self.interactor.ingridientsFilter
            await MainActor.run {
                router.entityshowIngridientsPicklist(dishId: dishId, filter: predicate) { selectedIds in
                    self.router.hideLast()
                    Task {
                        try await self.interactor.setSelectedIngridients(uids: selectedIds)
                        try await self.interactor.performWithDish { dish in
                            self.updateViewState(dish: dish)
                        }
                    }
                }
            }
        }
    }
    
    func editIngridientsTapped() {
        guard let dishId = interactor.dishId else {
            return
        }
        Task {
            try await valueSubmitted()
            let predicate = self.interactor.ingridientsFilter
            await MainActor.run {
                router.entityshowIngridientsPicklist(dishId: dishId, filter: predicate) { selectedIds in
                    self.router.hideLast()
                    Task {
                        try await self.interactor.setSelectedIngridients(uids: selectedIds)
                        try await self.interactor.performWithDish { dish in
                            self.updateViewState(dish: dish)
                        }
                    }
                }
            }
        }
    }
    
    func remove(ingridientId: UUID) {
        Task {
            try await interactor.remove(ingridientId: ingridientId)
            try await interactor.performWithDish { dish in
                self.updateViewState(dish: dish)
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
    
    private func updateViewState(dish: Dish?) {
        guard let viewState else {
            return
        }
        guard let dish else {
            viewState.error = "No entity"
            return
        }
        viewState.name = dish.name
        if let category = dish.category {
            var categoryColor: UIColor?
            if let colorHex = category.colorHex {
                categoryColor = try? UIColor(hex: colorHex)
            }
            viewState.category = DishCategoryViewModel(id: category.id,
                                                       name: category.name,
                                                       color: categoryColor)
        } else {
            viewState.category = nil
        }
        viewState.ingridients = if let ingridients = dish.ingridients {
            ingridients.map { ingridient in
                DishIngridientsListItem(id: ingridient.id,
                                        title: ingridient.name,
                                        subtitle: NumberFormatter.nutrientsDefaultString(calories: ingridient.calories,
                                                                                         proteins: ingridient.proteins,
                                                                                         fats: ingridient.fats,
                                                                                         carbs: ingridient.carbs),
                                        categoryColor: nil)
            }
        } else {
            []
        }
    }
    
    private func valueSubmitted() async throws {
        guard let viewState else {
            return
        }
        try await interactor.performWithDish { dish in
            dish?.name = viewState.name
        }
    }
}
