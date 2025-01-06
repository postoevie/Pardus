//
//  CategoriesListPresenter.swift
//  Pardus
//
//  Created by Igor Postoev on 23.7.24.
//
//

import SwiftUI

final class CategoriesListPresenter<MainEntity,
                                    DetailEntity,
                                    Interactor: CategoriesListInteractorProtocol,
                                    Customizer: CategoriesListPresenterCustomizerProtocol>:
                                        ObservableObject,
                                        CategoriesListPresenterProtocol where Interactor.MainEntity == MainEntity,
                                                                              Interactor.DetailEntity == DetailEntity,
                                                                              Customizer.MainEntity == MainEntity,
                                                                              Customizer.DetailEntity == DetailEntity {
    
    private let router: CategoriesListRouterProtocol
    private weak var viewState: (any CategoriesListViewStateProtocol)?
    private let interactor: Interactor
    private let customizer: Customizer
    
    init(router: CategoriesListRouterProtocol,
         interactor: Interactor,
         viewState: any CategoriesListViewStateProtocol,
         customizer: Customizer) {
        self.router = router
        self.interactor = interactor
        self.viewState = viewState
        self.customizer = customizer
    }
    
    func tapSearch() {
        router.showSearchList()
    }
    
    func tapNewCategory() {
        router.showAddCategory()
    }
    
    func tapNewDetail() {
        router.showAddDetail()
    }
    
    func tapEditDish(dishId: UUID) {
        router.showEditDetail(detailEntityId: dishId)
    }
    
    func delete(dishId: UUID) {
        // TODO: Make deletion approval
        Task {
            do {
                try await interactor.deleteDetailEntity(entityId: dishId)
                reloadSections()
            } catch let error as NSError where error.userInfo["NSValidationErrorKey"] as? String == "meals" {
                await MainActor.run {
                    viewState?.showAlert(title: String(localized: "categorieslist.alerts.refexist"))
                }
                return
            } catch {
                print(error)
            }
        }
    }
    
    func didAppear() {
        viewState?.setNavigationTitle(text: self.customizer.getNavigationTitle())
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
                try await interactor.deleteMainEntity(entityId: categoryId)
                reloadSections()
            } catch let error as NSError where error.userInfo["NSValidationErrorKey"] as? String == "dishes" {
                await MainActor.run {
                    viewState?.showAlert(title: String(localized: "categorieslist.alerts.refexist"))
                }
                return
            } catch {
                print(error) // TODO: Make error handling (P-3)
            }
        }
    }
    
    private func reloadSections() {
        Task {
            var sections = [CategoriesListSection]()
            await interactor.performWithDishData { data in
                sections = self.customizer.makeListSections(data: data)
            }
            await MainActor.run { [sections] in
                viewState?.set(sections: sections)
            }
        }
    }
    
    func tapEdit(categoryId: UUID) {
        router.showEditCategory(categoryId: categoryId)
    }
}
