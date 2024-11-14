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
    
    init(navigation: any NavigationServiceType){
        self.navigation = navigation
    }
    
    func showAddEntity() {
        navigation.items.append(.ingridientEdit(ingridientId: nil))
    }
    
    func showEditEntity(entityId: UUID) {
        navigation.items.append(.ingridientEdit(ingridientId: entityId))
    }
    
    func showCategories() {
        if Views.ingridientCategoriesList.isTypeIn(navigation.items) {
            _ = navigation.items.popLast()
            return
        }
        navigation.items.append(.ingridientCategoriesList)
    }
}
