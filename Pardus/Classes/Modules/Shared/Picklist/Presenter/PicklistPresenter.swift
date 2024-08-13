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
                let selectedItemIds = interactor.selectedItemIds
                viewState?.items = interactor.items.map {
                    mapToViewItem($0, selectedIds: selectedItemIds)
                }
            }
        }
    }
    
    func doneTapped() {
        completion(interactor.selectedItemIds)
    }
    
    func setSelected(item: PicklistViewItem) {
        interactor.setSelected(itemId: item.id)
        let selectedItemIds = interactor.selectedItemIds
        viewState?.items = interactor.items.map {
            mapToViewItem($0, selectedIds: selectedItemIds)
        }
    }
    
    private func mapToViewItem(_ item: PicklistDataItem, selectedIds: Set<UUID>) -> PicklistViewItem {
        switch item {
        case .dish(let model):
            let color: UIColor =
            if let colorHex = model.category?.colorHex,
               let color = try? UIColor(hex: colorHex) {
                color
            } else {
                .clear
            }
            let formatter = Formatter.dishNumbers
            let calString = formatter.string(for: model.calories) ?? "0"
            let proteinsString = formatter.string(for: model.proteins) ?? "0"
            let fatsString = formatter.string(for: model.fats) ?? "0"
            let carbohydratesString = formatter.string(for: model.carbohydrates) ?? "0"
            let subtitle = "\(calString) kcal \(proteinsString)/\(fatsString)/\(carbohydratesString)"
            return PicklistViewItem(id: model.id,
                                    isSelected: selectedIds.contains(model.id),
                                    type: .withSubtitle(title: model.name,
                                                        subtitle: subtitle,
                                                        indicatorColor: color))
        case .dishCategory(let model):
            let color: UIColor =
            if let color = try? UIColor(hex: model.colorHex) {
                color
            } else {
                .clear
            }
            return PicklistViewItem(id: model.id,
                                    isSelected: selectedIds.contains(model.id),
                                    type: .onlyTitle(title: model.name,
                                                     indicatorColor: color))
        }
    }
}
