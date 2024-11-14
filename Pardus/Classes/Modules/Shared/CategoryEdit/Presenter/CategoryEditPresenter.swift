//
//  DishCategoryEditPresenter.swift
//  Pardus
//
//  Created by Igor Postoev on 22.7.24.
//  
//

import SwiftUI

final class CategoryEditPresenter: ObservableObject, CategoryEditPresenterProtocol {
    
    private let router: CategoryEditRouterProtocol
    private weak var viewState: CategoryEditViewStateProtocol?
    private let interactor: CategoryEditInteractorProtocol
    
    init(router: CategoryEditRouterProtocol,
         interactor: CategoryEditInteractorProtocol,
         viewState: CategoryEditViewStateProtocol) {
        self.router = router
        self.interactor = interactor
        self.viewState = viewState
    }
    
    func onAppear() {
        Task {
            do {
                try await interactor.loadCategory()
                guard let categoryName = await interactor.categoryName,
                      let colorHex = await interactor.categoryColorHex else {
                    return
                }
                let color = try UIColor(hex: colorHex)
                await MainActor.run {
                    self.viewState?.name = categoryName
                    self.viewState?.color = color.cgColor
                }
            } catch {
                print(error)
            }
        }
    }
    
    func tapSave() {
        guard let viewState else {
            assertionFailure()
            return
        }
        Task {
            do {
                await interactor.set(categoryName: viewState.name)
                await interactor.set(categoryColorHex: UIColor(cgColor: viewState.color).toHex())
                try await interactor.save()
                await MainActor.run {
                    self.router.returnBack()
                }
            } catch {
                print(error)
            }
        }
    }
}
