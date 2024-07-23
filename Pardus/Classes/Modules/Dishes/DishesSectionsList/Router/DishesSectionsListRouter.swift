//
//  DishesSectionsListRouter.swift
//  Pardus
//
//  Created by Igor Postoev on 23.7.24.
//  
//

import Foundation

final class DishesSectionsListRouter: DishesSectionsListRouterProtocol {

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
    
    func showSearchList() {
        navigation.items.append(.dishList)
    }
}
