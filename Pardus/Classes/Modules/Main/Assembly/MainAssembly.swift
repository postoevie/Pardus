//
//  MainAssembly.swift
//  Pardus
//
//  Created by Igor Postoev on 11.5.24.
//  
//


import SwiftUI

final class MainAssembly: Assembly {
    
    func build() -> some View {
        
        let navigation = container.resolve(NavigationAssembly.self).build()

        // Router
        let router = MainRouter(navigation: navigation)

        // Interactor
        let interactor = MainInteractor()

        //ViewState
        let viewState = MainViewState()

        // Presenter
        let presenter = MainPresenter(router: router,
                                      interactor: interactor,
                                      viewState: viewState)
        
        // View
        let view = MainView(viewState: viewState, presenter: presenter)
        return view
    }
}