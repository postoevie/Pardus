//
//  DishEditAssembly.swift
//  Pardus
//
//  Created by Igor Postoev on 2.6.24.
//  
//


import SwiftUI

final class DishEditAssembly: Assembly {
    
    func build(dishId: UUID?) -> some View {
        
        let navigation = container.resolve(NavigationAssembly.self).build()

        // Router
        let router = DishEditRouter(navigation: navigation)

        // Interactor
        let coreDataStackService = container.resolve(CoreDataStackServiceAssembly.self).build()
        let coreDataService = CoreDataService(context: coreDataStackService.getMainQueueContext())
        let interactor = DishEditInteractor(coreDataService: coreDataService, dishId: dishId)

        //ViewState
        let viewState =  DishEditViewState()

        // Presenter
        let presenter = DishEditPresenter(router: router, interactor: interactor, viewState: viewState)
        
        // View
        let view = DishEditView(viewState: viewState, presenter: presenter)
        return view
    }
}
