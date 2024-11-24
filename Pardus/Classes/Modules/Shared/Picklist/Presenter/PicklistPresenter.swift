//
//  DishesPickPresenter.swift
//  Pardus
//
//  Created by Igor Postoev on 10.6.24.
//  
//

import SwiftUI
import Combine

final class PicklistPresenter: ObservableObject, DishesPickPresenterProtocol {
    
    weak var viewState: PicklistState?
    
    private let router: PicklistRouterProtocol
    private let interactor: PicklistInteractorProtocol
    private let completion: (Set<UUID>) -> Void
    
    init(router: PicklistRouterProtocol,
         interactor: PicklistInteractorProtocol,
         completion: @escaping (Set<UUID>) -> Void) {
        self.router = router
        self.interactor = interactor
        self.completion = completion
    }
    
    func didAppear() {
        Task {
            try await interactor.loadItems()
            await MainActor.run {
                viewState?.items = interactor.items
            }
        }
    }
    
    func doneTapped() {
        completion(interactor.selectedItemIds)
    }
    
    func setSelected(item: PicklistViewItem) {
        interactor.setSelected(itemId: item.id)
        viewState?.items = interactor.items
    }
}
