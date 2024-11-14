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
    
    init(navigation: any NavigationServiceType){
        self.navigation = navigation
    }
    
    func showAddDetail() {
        navigation.items.append(.dishEdit(dishId: nil))
    }

    func showAddCategory() {
        navigation.items.append(.dishCategoryEdit(dishCategoryId: nil))
    }
    
    func showEditCategory(categoryId: UUID) {
        navigation.items.append(.dishCategoryEdit(dishCategoryId: categoryId))
    }
    
    func showEditDetail(detailEntityId: UUID) {
        navigation.items.append(.dishEdit(dishId: detailEntityId))
    }
    
    func showSearchList() {
        if Views.dishList.isTypeIn(navigation.items) {
            _ = navigation.items.popLast()
            return
        }
        navigation.items.append(.dishList)
    }
}
