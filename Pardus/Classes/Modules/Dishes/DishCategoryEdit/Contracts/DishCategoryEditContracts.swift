//
//  DishCategoryEditContracts.swift
//  Pardus
//
//  Created by Igor Postoev on 22.7.24.
//  
//

import SwiftUI

// Router
protocol DishCategoryEditRouterProtocol: RouterProtocol {

    func returnBack()
}

// Presenter
protocol DishCategoryEditPresenterProtocol: PresenterProtocol {

}

// Interactor
protocol DishCategoryEditInteractorProtocol: InteractorProtocol {
    
    var category: DishCategoryModel? { get set }
    func loadCategory() async throws
    func update(name: String, color: UIColor) async throws
    func save() async throws
}

// ViewState
protocol DishCategoryEditViewStateProtocol: ViewStateProtocol {
    
    var name: String { get set }
    var color: CGColor { get set }
}
