//
//  DishesPickContracts.swift
//  Pardus
//
//  Created by Igor Postoev on 10.6.24.
//  
//

import SwiftUI

// Router
protocol PicklistRouterProtocol: RouterProtocol {

}

// Presenter
protocol DishesPickPresenterProtocol: PresenterProtocol {
    func didAppear()
    func setSelected(item: PicklistViewItem)
}

// Interactor
protocol PicklistInteractorProtocol: InteractorProtocol {
    var items: [PicklistDataItem] { get }
    var selectedItemIds: Set<UUID> { get }
    func setSelected(itemId: UUID)
    func loadItems() async throws
}

// ViewState
protocol DishesPicklistStateProtocol: ViewStateProtocol {
    var items: [PicklistViewItem] { get set }
}
