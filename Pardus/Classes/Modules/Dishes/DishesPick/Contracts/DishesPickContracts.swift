//
//  DishesPickContracts.swift
//  Pardus
//
//  Created by Igor Postoev on 10.6.24.
//  
//

import SwiftUI


// Router
protocol DishesPickRouterProtocol: RouterProtocol {

}

// Presenter
protocol DishesPickPresenterProtocol: PresenterProtocol {
    func didAppear()
    func getSelectedDishes() -> Set<DishPickViewModel>
    func setSelected(dish: DishPickViewModel)
}

// Interactor
protocol DishesPickInteractorProtocol: InteractorProtocol {
    var dishModels: [DishModel] { get }
    var selectedDishModels: [DishModel] { get }
    func setSelectedModels(dish: DishPickViewModel)
    func loadDishes() async throws
}

// ViewState
protocol DishesPicklistStateProtocol: ViewStateProtocol {
    var dishes: [DishPickViewModel] { get set }
    var selectedDishes: Set<DishPickViewModel> { get set }
}
