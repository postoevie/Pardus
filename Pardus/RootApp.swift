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
        container.apply(DishCategoryEditAssembly.self)
        container.apply(DishCategoriesPicklistAssembly.self)
        container.apply(DishEditAssembly.self)
        container.apply(DishesListAssembly.self)
        container.apply(DishPicklistAssembly.self)
        container.apply(DishCategoriesListAssembly.self)
        container.apply(MealDishEditAssembly.self)
        container.apply(MealsListAssembly.self)
        container.apply(MealEditAssembly.self)
        container.apply(IngridientsListAssembly.self)
        container.apply(IngridientEditAssembly.self)
        container.apply(IngridientCategoriesListAssembly.self)
        container.apply(IngridientCategoriesPicklistAssembly.self)
        container.apply(IngridientsPicklistAssembly.self)
        container.apply(IngridientCategoryEditAssembly.self)
        
        return container
    }()

    required init() {
        navigationService = NavigationAssembly.navigation
        appViewBuilder = ApplicationViewBuilder(container: container)
    }
    
    
    var body: some Scene {
        WindowGroup {
            RootView(navigationService: navigationService,
                     appViewBuilder: appViewBuilder)
                .onOpenURL { url in
                    if url.scheme == "pardus" {
                        // Handle the deep link here
                        print("App opened via deep link: \(url)")
                        // Navigate to specific view if needed
                    }
                }
        }
    }
}
