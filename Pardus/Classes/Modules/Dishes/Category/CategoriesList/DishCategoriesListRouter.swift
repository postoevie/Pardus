//
//  CategoriesListRouter.swift
//  Pardus
//
//  Created by Igor Postoev on 23.7.24.
//  
//

import Foundation

final class DishCategoriesListRouter: CategoriesListRouterProtocol {
    
    private var navigation: any NavigationServiceType
    
    init(navigation: any NavigationServiceType) {
        self.navigation = navigation
    }
    
    func showAddDetail() {
        navigation.dishesItems.append(.dishEdit(dishId: nil))
    }

    func showAddCategory() {
        navigation.dishesItems.append(.dishCategoryEdit(dishCategoryId: nil))
    }
    
    func showEditCategory(categoryId: UUID) {
        navigation.dishesItems.append(.dishCategoryEdit(dishCategoryId: categoryId))
    }
    
    func showEditDetail(detailEntityId: UUID) {
        navigation.dishesItems.append(.dishEdit(dishId: detailEntityId))
    }
    
    func showSearchList() {
        if Views.dishList.isTypeIn(navigation.dishesItems) {
            _ = navigation.dishesItems.popLast()
            return
        }
        navigation.dishesItems.append(.dishList)
    }
}
