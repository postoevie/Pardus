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
    
    init(navigation: any NavigationServiceType) {
        self.navigation = navigation
    }
    
    func showAddEntity() {
        navigation.dishesItems.append(.dishEdit(dishId: nil))
    }
    
    func showAddCategory() {
        navigation.dishesItems.append(.dishCategoryEdit(dishCategoryId: nil))
    }
    
    func showEditCategory(dishCategoryId: UUID) {
        navigation.dishesItems.append(.dishCategoryEdit(dishCategoryId: dishCategoryId))
    }
    
    func showEditEntity(entityId: UUID) {
        navigation.dishesItems.append(.dishEdit(dishId: entityId))
    }
    
    func showCategories() {
        if Views.dishCategoriesList.isTypeIn(navigation.dishesItems) {
            _ = navigation.dishesItems.popLast()
            return
        }
        navigation.dishesItems.append(.dishCategoriesList)
    }
    
    func showError(messageKey: String) {
        navigation.alert = .errorAlert(messageKey: messageKey)
    }
}
