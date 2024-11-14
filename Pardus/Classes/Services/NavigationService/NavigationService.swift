//
//  NavigationService.swift
//  Pardus
//
//  Created by Igor Postoev on 11.5.24.
//
//


import SwiftUI
import Combine

public class NavigationService: ObservableObject, Identifiable  {
    
    public let id = UUID()
    
    public static func == (lhs: NavigationService, rhs: NavigationService) -> Bool {
        lhs.id == rhs.id
    }
    
    @Published var mealsItems: [Views] = [.mealsList]
    @Published var dishesItems: [Views] = [.dishList]
    @Published var ingridientsItems: [Views] = [.ingridientsList]
    
    @Published var sheetView: Views?
    @Published var modalView: Views?
    @Published var alert: CustomAlert?
}


indirect enum Views: Equatable, Hashable {
    
    static func == (lhs: Views, rhs: Views) -> Bool {
        lhs.stringKey == rhs.stringKey
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.stringKey)
    }
    
    case mealsList
    case mealEdit(mealId: UUID?)
    case mealDishEdit(mealDishId: UUID?)
    case dishList
    case dishCategoriesList
    case dishEdit(dishId: UUID?)
    case dishPicklist(callingView: Views, type: PicklistType, filter: Predicate?, completion: (Set<UUID>) -> Void)
    case dishCategoryPicklist(callingView: Views, type: PicklistType, filter: Predicate?, completion: (Set<UUID>) -> Void)
    case dishIngridientsPicklist(callingView: Views, type: PicklistType, filter: Predicate?, completion: (Set<UUID>) -> Void)
    case dishCategoryEdit(dishCategoryId: UUID?)
    case ingridientsList
    case ingridientCategoriesList
    case ingridientEdit(ingridientId: UUID?)
    case ingridientCategoryPicklist(callingView: Views, type: PicklistType, filter: Predicate?, completion: (Set<UUID>) -> Void)
    case ingridientCategoryEdit(categoryId: UUID?)
    
    var stringKey: String {
        switch self {
        case .mealsList:
            return "mealsList"
        case .mealEdit:
            return "mealEdit"
        case .mealDishEdit:
            return "mealDishEdit"
        case .dishList:
            return "dishList"
        case .dishEdit:
            return "dishEdit"
        case .dishPicklist:
            return "dishPicklist"
        case .dishCategoryEdit:
            return "dishCategoryEdit"
        case .dishCategoriesList:
            return "dishCategoriesList"
        case .dishCategoryPicklist:
            return "dishCategoryPicklist"
        case .dishIngridientsPicklist:
            return "dishIngridientsPicklist"
        case .ingridientsList:
            return "ingridientsList"
        case .ingridientCategoriesList:
            return "ingridientCategoriesList"
        case .ingridientEdit:
            return "ingridientEdit"
        case .ingridientCategoryPicklist:
            return "ingridientCategoryPicklist"
        case .ingridientCategoryEdit:
            return "ingridientCategoryEdit"
        }
    }
    
    var navigationStem: NavigationStem {
        switch self {
        case .mealsList, .mealEdit:
            return .meals
        default:
            return .dishes
        }
    }
    
    func isTypeIn(_ views: [Views]) -> Bool {
        views.contains(where: { $0.stringKey == stringKey })
    }
}

enum CustomAlert: Equatable, Hashable {
    static func == (lhs: CustomAlert, rhs: CustomAlert) -> Bool {
        lhs.hashValue == rhs.hashValue
    }
    
    func hash(into hasher: inout Hasher) {
        switch self {
        case .defaultAlert:
            hasher.combine("defaultAlert")
        }
    }
    
    case defaultAlert(yesAction: (()->Void)?, noAction: (()->Void)?)
}
