//
//  DishesListRouter.swift
//  Pardus
//
//  Created by Igor Postoev on 2.6.24.
//  
//

import Foundation

final class DishesListRouter: DishesListRouterProtocol {

    private var navigation: any NavigationServiceType
    
    init(navigation: any NavigationServiceType){
        self.navigation = navigation
    }
    
    func showAddDish() {
        navigation.items.append(.dishEdit(dishId: nil))
    }
    
    func showAddCategory() {
        navigation.items.append(.dishCategoryEdit(dishCategoryId: nil))
    }
    
    func showEditCategory(dishCategoryId: UUID) {
        navigation.items.append(.dishCategoryEdit(dishCategoryId: dishCategoryId))
    }
    
    func showEditDish(dishId: UUID) {
        navigation.items.append(.dishEdit(dishId: dishId))
    }
    
    func showSections() {
        _ = navigation.items.popLast()
    }
}
