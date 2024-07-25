//
//  DishesSectionsListAssembly.swift
//  Pardus
//
//  Created by Igor Postoev on 23.7.24.
//  
//


import SwiftUI

final class DishesSectionsListAssembly: Assembly {
    
    func build() -> some View {
        
        let navigation = container.resolve(NavigationAssembly.self).build()

        // Router
        let router = DishesSectionsListRouter(navigation: navigation)

        // Interactor
        let coreDataStackService = container.resolve(CoreDataStackServiceAssembly.self).build()
        let coreDataService = CoreDataEntityService(context: coreDataStackService.makeChildMainQueueContext(),
                                                    caches: [:],
                                                    restoration: nil)
        let interactor = DishesSectionsListInteractor(modelService: coreDataService)

        //ViewState
        let viewState = DishesSectionsListViewState()

        // Presenter
        let presenter = DishesSectionsListPresenter(router: router,
                                                    interactor: interactor,
                                                    viewState: viewState)
        
        // View
        let view = DishesSectionsListView(viewState: viewState, presenter: presenter)
        return view
    }
}
