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
    
    let container: DependencyContainer = {
        let factory = AssemblyFactory()
        let container = DependencyContainer(assemblyFactory: factory)

        // Services
        container.apply(NavigationAssembly.self)
        container.apply(CoreDataStackServiceAssembly.self)
        container.apply(RecordsRestoreServiceAssembly.self)
        container.apply(MemoryPressureServiceAssembly.self)
        
        // Modules
        container.apply(RootAssembly.self)
        container.apply(MealsListAssembly.self)
        container.apply(MealEditAssembly.self)
        container.apply(MealDishEditAssembly.self)
        container.apply(MealIngridientEditAssembly.self)
        container.apply(DishCategoryEditAssembly.self)
        container.apply(DishCategoriesPicklistAssembly.self)
        container.apply(DishEditAssembly.self)
        container.apply(DishesListAssembly.self)
        container.apply(DishPicklistAssembly.self)
        container.apply(DishCategoriesListAssembly.self)
        container.apply(IngridientsListAssembly.self)
        container.apply(IngridientEditAssembly.self)
        container.apply(IngridientCategoriesListAssembly.self)
        container.apply(IngridientCategoriesPicklistAssembly.self)
        container.apply(IngridientsPicklistAssembly.self)
        container.apply(IngridientCategoryEditAssembly.self)
        
        return container
    }()

    required init() {
        appViewBuilder = ApplicationViewBuilder(container: container)
    }
    
    
    var body: some Scene {
        WindowGroup {
            container.resolve(RootAssembly.self).build(appViewBuilder: appViewBuilder)
                .accessibilityIdentifier("pardus.root")
        }
    }
}
