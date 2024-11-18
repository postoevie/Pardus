//
//  DishesListRouter.swift
//  Pardus
//
//  Created by Igor Postoev on 2.6.24.
//  
//

import Foundation

final class DishesListRouter: SearchListRouterProtocol {

    private var navigation: any NavigationServiceType
    
    init(navigation: any NavigationServiceType){
        self.navigation = navigation
    }
    
    func showAddEntity() {
        navigation.items.append(.dishEdit(dishId: nil))
    }
    
    func showAddCategory() {
        navigation.items.append(.dishCategoryEdit(dishCategoryId: nil))
    }
    
    func showEditCategory(dishCategoryId: UUID) {
        navigation.items.append(.dishCategoryEdit(dishCategoryId: dishCategoryId))
    }
    
    func showEditEntity(entityId: UUID) {
        navigation.items.append(.dishEdit(dishId: entityId))
    }
    
    func showCategories() {
        if Views.dishCategoriesList.isTypeIn(navigation.items) {
            _ = navigation.items.popLast()
            return
        }
        navigation.items.append(.dishCategoriesList)
    }
}
