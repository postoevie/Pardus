//
//  DishCategoryEditContracts.swift
//  Pardus
//
//  Created by Igor Postoev on 22.7.24.
//  
//

import SwiftUI

// Router
protocol CategoryEditRouterProtocol: RouterProtocol {

    func returnBack()
}

// Presenter
protocol CategoryEditPresenterProtocol: PresenterProtocol {

}

// Interactor
protocol CategoryEditInteractorProtocol: InteractorProtocol {
    
    var categoryName: String? { get async }
    var categoryColorHex: String? { get async }
    
    func set(categoryName: String) async
    func set(categoryColorHex: String) async
    func loadCategory() async throws
    func save() async throws
}

// ViewState
protocol CategoryEditViewStateProtocol: ViewStateProtocol {
    
    var name: String { get set }
    var color: CGColor { get set }
}
