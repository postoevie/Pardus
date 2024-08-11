//
//  NavigationAssembly.swift
//  Pardus
//
//  Created by Igor Postoev on 11.5.24.
//  
//

import Foundation

enum NavigationStem {
    case meals
    case dishes
}

final class NavigationAssembly: Assembly {
    
    //Only one navigation should use in app
    static let navigation = NavigationService()
    
    func build(stem: NavigationStem) -> any NavigationServiceType {
        switch stem {
        case .meals:
            MealsNavigationService(navigationService: NavigationAssembly.navigation)
        case .dishes:
            DishesNavigationService(navigationService: NavigationAssembly.navigation)
        }
    }
}

fileprivate final class MealsNavigationService: NavigationServiceType {
    
    let navigationService: NavigationService
    
    init(navigationService: NavigationService) {
        self.navigationService = navigationService
    }
    
    var items: [Views] {
        get {
            navigationService.mealsItems
        }
        set {
            navigationService.mealsItems = newValue
        }
    }
    
    var modalView: Views? {
        get {
            navigationService.modalView
        }
        set {
            navigationService.modalView = newValue
        }
    }
    
    var alert: CustomAlert? {
        get {
            navigationService.alert
        }
        set {
            navigationService.alert = newValue
        }
    }
    
    var sheetView: Views? {
        get {
            navigationService.sheetView
        }
        set {
            navigationService.sheetView = newValue
        }
    }
}

fileprivate final class DishesNavigationService: NavigationServiceType {
    
    let navigationService: NavigationService
    
    init(navigationService: NavigationService) {
        self.navigationService = navigationService
    }
    
    var items: [Views] {
        get {
            navigationService.dishesItems
        }
        set {
            navigationService.dishesItems = newValue
        }
    }
    
    var modalView: Views? {
        get {
            navigationService.modalView
        }
        set {
            navigationService.modalView = newValue
        }
    }
    
    var alert: CustomAlert? {
        get {
            navigationService.alert
        }
        set {
            navigationService.alert = newValue
        }
    }
    
    var sheetView: Views? {
        get {
            navigationService.sheetView
        }
        set {
            navigationService.sheetView = newValue
        }
    }
}
