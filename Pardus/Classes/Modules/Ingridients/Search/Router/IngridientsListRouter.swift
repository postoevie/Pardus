//
//  IngridientsListRouter.swift
//  Pardus
//
//  Created by Igor Postoev on 29.10.24.
//  
//

import Foundation

final class IngridientsListRouter: SearchListRouterProtocol {

    private var navigation: any NavigationServiceType
    
    init(navigation: any NavigationServiceType) {
        self.navigation = navigation
    }
    
    func showAddEntity() {
        navigation.ingridientsItems.append(.ingridientEdit(ingridientId: nil))
    }
    
    func showEditEntity(entityId: UUID) {
        navigation.ingridientsItems.append(.ingridientEdit(ingridientId: entityId))
    }
    
    func showCategories() {
        if Views.ingridientCategoriesList.isTypeIn(navigation.ingridientsItems) {
            _ = navigation.ingridientsItems.popLast()
            return
        }
        navigation.ingridientsItems.append(.ingridientCategoriesList)
    }
}
