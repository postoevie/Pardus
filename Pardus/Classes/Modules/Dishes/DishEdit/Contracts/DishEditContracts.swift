//
//  DishEditContracts.swift
//  Pardus
//
//  Created by Igor Postoev on 2.6.24.
//  
//

import SwiftUI


// Router
protocol DishEditRouterProtocol: RouterProtocol {

    func returnBack()
}

// Presenter
protocol DishEditPresenterProtocol: PresenterProtocol {

    func didAppear()
    func doneTapped()
}

// Interactor
protocol DishEditInteractorProtocol: InteractorProtocol {

    var dish: DishModel? { get }
    
    func loadInitialDish() async throws
    func update(model: DishModel) async throws
    func save() async throws
}

// ViewState
protocol DishEditViewStateProtocol: ViewStateProtocol {
    var name: String { get set }
    var error: String? { get set }
}
