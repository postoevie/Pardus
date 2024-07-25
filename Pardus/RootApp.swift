//
//  RootApp.swift
//  Pardus
//
//  Created by Igor Postoev on 11.5.24.
//  
//

import SwiftUI

@main
class RootApp: App {
    
    @ObservedObject var appViewBuilder: ApplicationViewBuilder
    @ObservedObject var navigationService: NavigationService
    
    let container: DependencyContainer = {
        let factory = AssemblyFactory()
        let container = DependencyContainer(assemblyFactory: factory)

        // Services
        container.apply(NavigationAssembly.self)
        container.apply(CoreDataStackServiceAssembly.self)
        container.apply(CoreDataRestorationStoreAssembly.self)
    
        // Modules
        container.apply(MainAssembly.self)
        container.apply(MealsListAssembly.self)
        container.apply(MealEditAssembly.self)
        container.apply(DishesListAssembly.self)
        container.apply(DishEditAssembly.self)
        container.apply(PicklistAssembly.self)
        container.apply(DishCategoryEditAssembly.self)
        container.apply(DishesSectionsListAssembly.self)
        
        return container
    }()

    required init() {
        navigationService = container.resolve(NavigationAssembly.self).build() as! NavigationService
        
        appViewBuilder = ApplicationViewBuilder(container: container)
    }
    
    
    var body: some Scene {
        WindowGroup {
            RootView(navigationService: navigationService,
                     appViewBuilder: appViewBuilder)
        }
    }
    
    
}
