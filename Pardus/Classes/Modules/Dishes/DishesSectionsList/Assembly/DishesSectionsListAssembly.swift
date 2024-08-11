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
        
        let navigation = container.resolve(NavigationAssembly.self).build(stem: .dishes)

        // Router
        let router = DishesSectionsListRouter(navigation: navigation)

        // Interactor
        let coreDataStackService = container.resolve(CoreDataStackServiceAssembly.self).build()
        let coreDataService = CoreDataEntityService(context: coreDataStackService.getMainQueueContext())
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
    
    func preview() -> some View {
        
        let navigation = container.resolve(NavigationAssembly.self).build(stem: .dishes)

        // Router
        let router = DishesSectionsListRouter(navigation: navigation)

        // Interactor
        let coreDataStackService = CoreDataStackInMemoryService()
        
        let context = coreDataStackService.getMainQueueContext()
        
        let dishCategory = DishCategory(context: context)
        dishCategory.name = "Salads"
        dishCategory.colorHex = "#00AA00"
        dishCategory.id = UUID()
        
        let dish = Dish(context: context)
        dish.name = "Grcka salata"
        dish.category = dishCategory
        dish.id = UUID()
        
        try? context.save()
        
        let coreDataService = CoreDataEntityService(context: context)
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
