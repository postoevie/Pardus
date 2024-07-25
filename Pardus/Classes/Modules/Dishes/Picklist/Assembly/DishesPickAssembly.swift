//
//  DishesPickAssembly.swift
//  Pardus
//
//  Created by Igor Postoev on 10.6.24.
//  
//


import SwiftUI

final class PicklistAssembly: Assembly {
    
    func build(callingView: Views, _ preselected: Set<UUID>, _ completion: @escaping (Set<UUID>) -> Void) -> some View {
        
        let navigation = container.resolve(NavigationAssembly.self).build()

        // Router
        let router = PicklistRouter(navigation: navigation)

        // Interactor
        let coreDataStackService = container.resolve(CoreDataStackServiceAssembly.self).build()
        let restoration = container.resolve(CoreDataRestorationStoreAssembly.self).build()
        let restorated = restoration.restore(key: callingView)
        let coreDataService = CoreDataEntityService(context: restorated?.context ?? coreDataStackService.makeChildMainQueueContext(),
                                                    caches: [:],
                                                    restoration: nil)
        let interactor: PicklistInteractorProtocol = switch callingView {
        case .dishEdit:
            DishCategoriesPicklistInteractor(modelService: coreDataService, preselectedCategoryIds: preselected)
        default:
            DishesPicklistInteractor(modelService: coreDataService, preselectedDishesIds: preselected)
        }

        // Presenter
        let presenter = PicklistPresenter(router: router, interactor: interactor, completion: completion)
        
        //ViewState
        let viewState = PicklistState()
        presenter.viewState = viewState
        
        // View
        let view = PicklistView(viewState: viewState, presenter: presenter)
        return view
    }
}
