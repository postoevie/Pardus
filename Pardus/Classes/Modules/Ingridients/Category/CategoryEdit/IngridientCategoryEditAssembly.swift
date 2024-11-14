//
//  IngridientCategoryEditAssembly.swift
//  Pardus
//
//  Created by Igor Postoev on 14.11.24..
//

import SwiftUI

final class IngridientCategoryEditAssembly: Assembly {
    
    func build(categoryId: UUID?) -> some View {
        
        let navigation = container.resolve(NavigationAssembly.self).build(stem: .ingridients)

        // Router
        let router = CategoryEditRouter(navigation: navigation)

        // Interactor
        let coreDataStackService = container.resolve(CoreDataStackServiceAssembly.self).build()
        let coreDataService = CoreDataService(context: coreDataStackService.makeChildMainQueueContext())
        let interactor = CategoryEditInteractor<IngridientCategory>(coreDataService: coreDataService,
                                                                    categoryId: categoryId)

        //ViewState
        let viewState = CategoryEditViewState()

        // Presenter
        let presenter = CategoryEditPresenter(router: router, interactor: interactor, viewState: viewState)
        
        // View
        let view = CategoryEditView(viewState: viewState, presenter: presenter)
        return view
    }
}

