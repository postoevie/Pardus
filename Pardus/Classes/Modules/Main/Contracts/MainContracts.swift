//
//  MainContracts.swift
//  Pardus
//
//  Created by Igor Postoev on 11.5.24.
//  
//

import SwiftUI


// Router
protocol MainRouterProtocol: RouterProtocol {

    func navigateToMealsList()
}

// Presenter
protocol MainPresenterProtocol: ObservableObject, PresenterProtocol {
    
    func didAppear()
}

// Interactor
protocol MainInteractorProtocol: InteractorProtocol {

}

// ViewState
protocol MainViewStateProtocol: ViewStateProtocol {
    
}
