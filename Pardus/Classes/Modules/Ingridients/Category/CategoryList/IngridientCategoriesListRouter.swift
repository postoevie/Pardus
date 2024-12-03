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
        navigation.ingridientsItems.append(.ingridientEdit(ingridientId: nil))
    }
    
    func showAddCategory() {
        navigation.ingridientsItems.append(.ingridientCategoryEdit(categoryId: nil))
    }
    
    func showEditCategory(categoryId: UUID) {
        navigation.ingridientsItems.append(.ingridientCategoryEdit(categoryId: categoryId))
    }
    
    func showEditDetail(detailEntityId: UUID) {
        navigation.ingridientsItems.append(.ingridientEdit(ingridientId: detailEntityId))
    }
    
    func showSearchList() {
        if Views.ingridientsList.isTypeIn(navigation.ingridientsItems) {
            _ = navigation.ingridientsItems.popLast()
            return
        }
        navigation.ingridientsItems.append(.ingridientsList)
    }
}

