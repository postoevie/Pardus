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
        let categories = interactor.dishCategories
        let sections: [DishListSection] = categories.map { category in
            .init(category: .init(id: category.id,
                                  name: category.name,
                                  color: try? .init(hex: category.colorHex)),
                  dishes: groupedDishes[category.id]?.map { DishViewModel(model: $0) } ?? [])
        }
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
    
    
    func delete(categoryId: UUID) {
        Task {
            do {
                try await interactor.deleteDishCategory(categoryId: categoryId)
                try await interactor.loadDishes()
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
