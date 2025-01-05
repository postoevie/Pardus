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
    private weak var viewState: (any DishEditViewStateProtocol)?
    private let interactor: DishEditInteractorProtocol
    
    init(router: DishEditRouterProtocol,
         interactor: DishEditInteractorProtocol,
         viewState: (any DishEditViewStateProtocol)?) {
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
            await self.interactor.performWithIngridients { ingridients in
                self.updateViewState(ingridients: ingridients)
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
                    self.router.hidePicklist()
                    Task {
                        try await self.interactor.setCategory(uid: selected.first)
                        try await self.interactor.save()
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
                router.showIngridientsPicklist(dishId: dishId, filter: predicate) { selectedIds in
                    self.router.hidePicklist()
                    Task {
                        try await self.interactor.setSelectedIngridients(uids: selectedIds)
                        try await self.interactor.save()
                        await self.interactor.performWithIngridients { ingridients in
                            self.updateViewState(ingridients: ingridients)
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
                router.showIngridientsPicklist(dishId: dishId, filter: predicate) { selectedIds in
                    self.router.hidePicklist()
                    Task {
                        try await self.interactor.setSelectedIngridients(uids: selectedIds)
                        try await self.interactor.save()
                        await self.interactor.performWithIngridients { ingridients in
                            self.updateViewState(ingridients: ingridients)
                        }
                    }
                }
            }
        }
    }
    
    func remove(ingridientId: UUID) {
        Task {
            try await interactor.remove(ingridientId: ingridientId)
            try await self.interactor.save()
            await interactor.performWithIngridients { ingridients in
                self.updateViewState(ingridients: ingridients)
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
    
    private func updateViewState(dish: Dish?) {
        guard let viewState else {
            return
        }
        guard let dish else {
            viewState.error = "errors.absendentity"
            return
        }
        
        let name = dish.name
        var categoryModel: DishCategoryViewModel?
        if let category = dish.category {
            var categoryColor: Color = .clear
            if let colorHex = category.colorHex,
               let color = try? UIColor.init(hex: colorHex) {
                categoryColor = Color(color)
            }
            categoryModel = DishCategoryViewModel(id: category.id,
                                                  name: category.name,
                                                  color: categoryColor)
        }
        
        DispatchQueue.main.async {
            viewState.name = name
            viewState.category = categoryModel
        }
    }
    
    private func updateViewState(ingridients: [Ingridient]) {
        guard let viewState else {
            return
        }
        let ingridientItems = ingridients.map(mapToListItem)
        DispatchQueue.main.async {
            viewState.ingridients = ingridientItems
        }
    }
    
    private func mapToListItem(_ ingridient: Ingridient) -> DishIngridientsListItem {
        DishIngridientsListItem(id: ingridient.id,
                                title: ingridient.name,
                                subtitle: NumberFormatter.nutrientsDefaultString(calories: ingridient.calories,
                                                                                 proteins: ingridient.proteins,
                                                                                 fats: ingridient.fats,
                                                                                 carbs: ingridient.carbs),
                                categoryColor: .clear)
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
