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

}

// Presenter
protocol MainPresenterProtocol: PresenterProtocol {

}

// Interactor
protocol MainInteractorProtocol: InteractorProtocol {

}

// ViewState
protocol MainViewStateProtocol: ViewStateProtocol {
    func set(with presenter: MainPresenterProtocol)
}
