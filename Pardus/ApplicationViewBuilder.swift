//
//  ApplicationViewBuilder.swift
//  Pardus
//
//  Created by Igor Postoev on 11.5.24.
//  
//

import SwiftUI

final class ApplicationViewBuilder : Assembly, ObservableObject {
    
    required init(container: Container) {
        super.init(container: container)
    }
   
    @ViewBuilder
    func build(view: Views) -> some View {
        switch view {
        case .main:
            buildMain()
        case .mealsList :
            buildMealsList()
        case .mealEdit(let mealId):
            buildMealEdit(mealId)
        case .dishList:
            buildDishList()
        case .dishEdit(let dishId):
            buildDishEdit(dishId)
        case .picklist(let caller, let preselected, let completion):
            buildDishPick(caller, preselected, completion)
        case .dishCategoryEdit(dishCategoryId: let dishCategoryId):
            buildDishCategoryEdit(dishCategoryId)
        case .dishesSectionsList:
            buildDishSectionList()
        case .dishCategoryPick(let callingView, let preselected, let completion):
            buildDishCategoryPick(callingView, preselected, completion)
        }
    }
    
    @ViewBuilder
    fileprivate func buildMain() -> some View {
        container.resolve(MainAssembly.self).build()
    }
    
    @ViewBuilder
    fileprivate func buildMealsList() -> some View {
        container.resolve(MealsListAssembly.self).build()
    }
    
    @ViewBuilder
    fileprivate func buildMealEdit(_ mealId: UUID?) -> some View {
        container.resolve(MealEditAssembly.self).build(mealId: mealId)
    }
    
    @ViewBuilder
    fileprivate func buildDishList() -> some View {
        container.resolve(DishesListAssembly.self).build()
    }
    
    @ViewBuilder
    fileprivate func buildDishEdit(_ dishId: UUID?) -> some View {
        container.resolve(DishEditAssembly.self).build(dishId: dishId)
    }
    
    @ViewBuilder
    fileprivate func buildDishPick(_ caller: Views,
                                   _ preselected: Set<UUID>,
                                   _ completion: @escaping (Set<UUID>) -> Void) -> some View {
        container.resolve(PicklistAssembly.self).build(callingView: caller, preselected, completion)
    }
    
    @ViewBuilder
    fileprivate func buildDishCategoryEdit(_ dishCategoryId: UUID?) -> some View {
        container.resolve(DishCategoryEditAssembly.self).build(dishCategoryId: dishCategoryId)
    }
    
    @ViewBuilder
    fileprivate func buildDishSectionList() -> some View {
        container.resolve(DishesSectionsListAssembly.self).build()
    }
    
    @ViewBuilder
    fileprivate func buildDishCategoryPick(_ caller: Views,
                                           _ preselected: Set<UUID>,
                                           _ completion: @escaping (Set<UUID>) -> Void) -> some View {
        container.resolve(PicklistAssembly.self).build(callingView: caller, preselected, completion)
    }
}

final class ApplicationPreviewBuilder : Assembly, ObservableObject {
    
    required init(container: Container) {
        super.init(container: container)
    }
   
    @ViewBuilder
    func build(view: Views) -> some View {
        switch view {
        case .main:
            buildMain()
        case .mealsList :
            buildMealsList()
        case .mealEdit(let mealId):
            buildMealEdit(mealId)
        case .dishList:
            buildDishList()
        case .dishEdit(let dishId):
            buildDishEdit(dishId)
        case .picklist(let caller, let preselected, let completion):
            buildPicklist(caller, preselected, completion)
        case .dishCategoryEdit(dishCategoryId: let dishCategoryId):
            buildDishCategoryEdit(dishCategoryId)
        case .dishesSectionsList:
            buildDishSectionList()
        case .dishCategoryPick(let callingView, let preselected, let completion):
            buildDishCategoryPick(callingView, preselected, completion)
        }
    }
    
    @ViewBuilder
    fileprivate func buildMain() -> some View {
        container.resolve(MainAssembly.self).build()
    }
    
    @ViewBuilder
    fileprivate func buildMealsList() -> some View {
        container.resolve(MealsListAssembly.self).preview()
    }
    
    @ViewBuilder
    fileprivate func buildMealEdit(_ mealId: UUID?) -> some View {
        container.resolve(MealEditAssembly.self).build(mealId: mealId)
    }
    
    @ViewBuilder
    fileprivate func buildDishList() -> some View {
        container.resolve(DishesListAssembly.self).preview()
    }
    
    @ViewBuilder
    fileprivate func buildDishEdit(_ dishId: UUID?) -> some View {
        container.resolve(DishEditAssembly.self).build(dishId: dishId)
    }
    
    @ViewBuilder
    fileprivate func buildPicklist(_ caller: Views,
                                   _ preselected: Set<UUID>,
                                   _ completion: @escaping (Set<UUID>) -> Void) -> some View {
        container.resolve(PicklistAssembly.self).preview(callingView: caller, preselected, completion)
    }
    
    @ViewBuilder
    fileprivate func buildDishCategoryEdit(_ dishCategoryId: UUID?) -> some View {
        container.resolve(DishCategoryEditAssembly.self).build(dishCategoryId: dishCategoryId)
    }
    
    @ViewBuilder
    fileprivate func buildDishSectionList() -> some View {
        container.resolve(DishesSectionsListAssembly.self).build()
    }
    
    @ViewBuilder
    fileprivate func buildDishCategoryPick(_ caller: Views,
                                           _ preselected: Set<UUID>,
                                           _ completion: @escaping (Set<UUID>) -> Void) -> some View {
        container.resolve(PicklistAssembly.self).build(callingView: caller, preselected, completion)
    }
}

extension ApplicationViewBuilder {
    
    static var stub: ApplicationViewBuilder {
        return ApplicationViewBuilder(
            container: RootApp().container
        )
    }
    
    static var preview: ApplicationPreviewBuilder {
        return ApplicationPreviewBuilder(
            container: RootApp().container
        )
    }
}
