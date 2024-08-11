//
//  DishesSectionsListPresenter.swift
//  Pardus
//
//  Created by Igor Postoev on 23.7.24.
//  
//

import SwiftUI

final class DishesSectionsListPresenter: ObservableObject, DishesSectionsListPresenterProtocol {
    
    private let router: DishesSectionsListRouterProtocol
    private weak var viewState: DishesSectionsListViewStateProtocol?
    private let interactor: DishesSectionsListInteractorProtocol
    
    init(router: DishesSectionsListRouterProtocol,
         interactor: DishesSectionsListInteractorProtocol,
         viewState: DishesSectionsListViewStateProtocol) {
        self.router = router
        self.interactor = interactor
        self.viewState = viewState
    }
    
    func tapSearch() {
        router.showSearchList()
    }
    
    func tapNewCategory() {
        interactor.stashState()
        router.showAddCategory()
    }
    
    private func reloadSections() {
        let groupedDishes = Dictionary(grouping: interactor.dishes) { $0.category?.id }
        if groupedDishes.isEmpty {
            viewState?.set(sections: [])
            return
        }
        let categories = interactor.dishCategories
        var sections: [DishListSection] = categories.map { category in
            DishListSection(categoryId: category.id,
                            title: category.name,
                            color: try? .init(hex: category.colorHex),
                            dishes: groupedDishes[category.id]?.map { DishesListItem(model: $0) } ?? [])
            
        }
        sections.append(DishListSection(categoryId: nil,
                                        title: "No category",
                                        color: .lightGray,
                                        dishes: groupedDishes[nil]?.map { DishesListItem(model: $0) } ?? []))
        viewState?.set(sections: sections)
    }
    
    func tapNewDish() {
        interactor.stashState()
        router.showAddDish()
    }
    
    func tapEditDish(dishId: UUID) {
        router.showEditDish(dishId: dishId)
    }
    
    func delete(dishId: UUID) {
        // TODO: Make deletion approval
        Task {
            do {
                try await interactor.deleteDish(dishId: dishId)
                try await interactor.loadDishes()
            } catch {
                print(error) // TODO: Make error handling (P-3)
            }
            await MainActor.run {
                reloadSections()
            }
        }
    }
    
    func didAppear() {
        Task {
            try await interactor.loadDishes()
            await MainActor.run {
                reloadSections()
            }
        }
    }
    
    func okAlertTapped() {
        viewState?.hideAlert()
    }
    
    func delete(categoryId: UUID) {
        Task {
            do {
                try await interactor.deleteDishCategory(categoryId: categoryId)
                try await interactor.loadDishes()
            } catch let error as NSError where error.userInfo["NSValidationErrorKey"] as? String == "dishes" {
                await MainActor.run {
                    viewState?.showAlert(title: String(localized: "CantDeleteDishesExist"))
                }
                return
            } catch {
                print(error) // TODO: Make error handling (P-3)
            }
            await MainActor.run {
                reloadSections()
            }
        }
    }
    
    func tapEdit(categoryId: UUID) {
        router.showEditCategory(dishCategoryId: categoryId)
    }
}
