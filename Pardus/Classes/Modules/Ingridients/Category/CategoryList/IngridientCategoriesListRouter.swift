//
//  IngridientCategoriesListRouter.swift
//  Pardus
//
//  Created by Igor Postoev on 14.11.24..
//

import Foundation

final class IngridientCategoriesListRouter: CategoriesListRouterProtocol {

    private var navigation: any NavigationServiceType
    
    init(navigation: any NavigationServiceType){
        self.navigation = navigation
    }
    
    func showAddDetail() {
        navigation.items.append(.ingridientEdit(ingridientId: nil))
    }
    
    func showAddCategory() {
        navigation.items.append(.ingridientCategoryEdit(categoryId: nil))
    }
    
    func showEditCategory(categoryId: UUID) {
        navigation.items.append(.ingridientCategoryEdit(categoryId: categoryId))
    }
    
    func showEditDetail(detailEntityId: UUID) {
        navigation.items.append(.ingridientEdit(ingridientId: detailEntityId))
    }
    
    func showSearchList() {
        if Views.ingridientsList.isTypeIn(navigation.items) {
            _ = navigation.items.popLast()
            return
        }
        navigation.items.append(.ingridientsList)
    }
}

