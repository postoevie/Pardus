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
        case .mealsList :
            buildMealsList()
        case .mealEdit(let mealId):
            buildMealEdit(mealId)
        case .mealDishEdit(let mealDishId):
            buildMealDishEdit(mealDishId)
        case .dishList:
            buildDishList()
        case .dishEdit(let dishId):
            buildDishEdit(dishId)
        case .dishCategoryEdit(dishCategoryId: let dishCategoryId):
            buildDishCategoryEdit(dishCategoryId)
        case .dishCategoriesList:
            buildDishCategoriesList()
        case .dishCategoryPicklist(let type, let filter, let completion):
            buildDishCategoryPick(type, filter, completion)
        case .dishIngridientsPicklist(let type, let filter, let completion):
            buildIngridientPicklist(type, filter, completion)
        case .dishPicklist(let type, let filter, let completion):
            buildDishPicklist(type, filter, completion)
        case .ingridientsList:
            buildIngridientsList()
        case .ingridientCategoriesList:
            buildIngridientsCategoryList()
        case .ingridientEdit(ingridientId: let ingridientId):
            buildIngridientEdit(ingridientId)
        case .ingridientCategoryPicklist(let type, let filter, let completion):
            buildIngridientCategoryPicklist(type, filter, completion)
        case .ingridientCategoryEdit(categoryId: let categoryId):
            buildIngridientCategoryEdit(categoryId)
        }
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
    fileprivate func buildMealDishEdit(_ mealDishId: UUID?) -> some View {
        container.resolve(MealDishEditAssembly.self).build(mealDishId: mealDishId)
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
    fileprivate func buildDishPicklist(_ type: PicklistType,
                                       _ filter: Predicate?,
                                       _ completion: @escaping (Set<UUID>) -> Void) -> some View {
        container.resolve(DishPicklistAssembly.self).build(type: type,
                                                           filter: filter,
                                                           completion: completion)
    }
    
    @ViewBuilder
    fileprivate func buildDishCategoryEdit(_ dishCategoryId: UUID?) -> some View {
        container.resolve(DishCategoryEditAssembly.self).build(dishCategoryId: dishCategoryId)
    }
    
    @ViewBuilder
    fileprivate func buildDishCategoriesList() -> some View {
        container.resolve(DishCategoriesListAssembly.self).build()
    }
    
    @ViewBuilder
    fileprivate func buildDishCategoryPick(_ type: PicklistType,
                                           _ filter: Predicate?,
                                           _ completion: @escaping (Set<UUID>) -> Void) -> some View {
        container.resolve(DishCategoriesPicklistAssembly.self).build(type: type,
                                                                     filter: filter,
                                                                     completion: completion)
    }
    
    @ViewBuilder
    fileprivate func buildIngridientsList() -> some View {
        container.resolve(IngridientsListAssembly.self).build()
    }
    
    @ViewBuilder
    fileprivate func buildIngridientsCategoryList() -> some View {
        container.resolve(IngridientCategoriesListAssembly.self).build()
    }
    
    @ViewBuilder
    fileprivate func buildIngridientEdit(_ ingridientId: UUID?) -> some View {
        container.resolve(IngridientEditAssembly.self).build(ingridientId: ingridientId)
    }
    
    
    @ViewBuilder
    fileprivate func buildIngridientPicklist(_ type: PicklistType,
                                             _ filter: Predicate?,
                                             _ completion: @escaping (Set<UUID>) -> Void) -> some View {
        container.resolve(IngridientsPicklistAssembly.self).build(type: type,
                                                                  filter: filter,
                                                                  completion: completion)
    }
    
    @ViewBuilder
    fileprivate func buildIngridientCategoryEdit(_ categoryId: UUID?) -> some View {
        container.resolve(IngridientCategoryEditAssembly.self).build(categoryId: categoryId)
    }
    
    @ViewBuilder
    fileprivate func buildIngridientCategoryPicklist(_ type: PicklistType,
                                                     _ filter: Predicate?,
                                                     _ completion: @escaping (Set<UUID>) -> Void) -> some View {
        container.resolve(IngridientCategoriesPicklistAssembly.self).build(type: type,
                                                                           filter: filter,
                                                                           completion: completion)
    }
}

extension ApplicationViewBuilder {
    
    static var stub: ApplicationViewBuilder {
        return ApplicationViewBuilder(
            container: RootApp().container
        )
    }
}
