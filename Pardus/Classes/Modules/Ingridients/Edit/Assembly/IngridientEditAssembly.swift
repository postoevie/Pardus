//
//  IngridientEditAssembly.swift
//  Pardus
//
//  Created by Igor Postoev on 2.6.24.
//  
//


import SwiftUI

final class IngridientEditAssembly: Assembly {
    
    func build(ingridientId: UUID?) -> some View {
        
        let navigation = container.resolve(NavigationAssembly.self).build(stem: .ingridients)

        // Router
        let router = IngridientEditRouter(navigation: navigation)

        // Interactor
        let coreDataStackService = container.resolve(CoreDataStackServiceAssembly.self).build()
        let coreDataService = CoreDataService(context: coreDataStackService.makeChildMainQueueContext())
        let interactor = IngridientEditInteractor(coreDataService: coreDataService, ingridientId: ingridientId)

        //ViewState
        let viewState =  IngridientEditViewState()

        // Presenter
        let presenter = IngridientEditPresenter(router: router, interactor: interactor, viewState: viewState)
        
        // View
        let view = IngridientEditView(viewState: viewState, presenter: presenter)
        return view
    }
}
