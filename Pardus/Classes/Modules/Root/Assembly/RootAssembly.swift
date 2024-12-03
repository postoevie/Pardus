//
//  RootAssembly.swift
//  Pardus
//
//  Created by Igor Postoev on 2.12.24.
//  
//


import SwiftUI

final class RootAssembly: Assembly {
    
    func build(appViewBuilder: ApplicationViewBuilder) -> some View {
        
        let navigation = NavigationAssembly.navigation

        // Router
        let router = RootRouter(navigationService: navigation)

        // Interactor
        let restoreService = container.resolve(RecordsRestoreServiceAssembly.self).build()
        let interactor = RootInteractor(restoreRecordsService: restoreService)

        // Presenter
        let presenter = RootPresenter(router: router, interactor: interactor)
        
        // View
        let view = RootView(navigationService: navigation,
                            appViewBuilder: appViewBuilder,
                            presenter: presenter)
        return view
    }
}
