//
//  DishCategoryEditPresenter.swift
//  Pardus
//
//  Created by Igor Postoev on 22.7.24.
//  
//

import SwiftUI

final class DishCategoryEditPresenter: ObservableObject, DishCategoryEditPresenterProtocol {
    
    private let router: DishCategoryEditRouterProtocol
    private weak var viewState: DishCategoryEditViewStateProtocol?
    private let interactor: DishCategoryEditInteractorProtocol
    
    init(router: DishCategoryEditRouterProtocol,
         interactor: DishCategoryEditInteractorProtocol,
         viewState: DishCategoryEditViewStateProtocol) {
        self.router = router
        self.interactor = interactor
        self.viewState = viewState
    }
    
    func onAppear() {
        Task {
            do {
                try await interactor.loadCategory()
                guard let category = interactor.category else {
                    return
                }
                let color = try UIColor(hex: category.colorHex)
                await MainActor.run {
                    self.viewState?.name = category.name
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
                try await interactor.update(name: viewState.name, color: UIColor(cgColor: viewState.color))
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
