//
//  NavigationService.swift
//  Pardus
//
//  Created by Igor Postoev on 11.5.24.
//
//


import SwiftUI
import Combine

public class NavigationService: NavigationServiceType, ObservableObject, Identifiable  {
    
    public let id = UUID()
    
    public static func == (lhs: NavigationService, rhs: NavigationService) -> Bool {
        lhs.id == rhs.id
    }
    
    @Published var tab: Tabs = .meals
    @Published var mealsItems: [Views] = [.mealsList]
    @Published var dishesItems: [Views] = [.dishList]
    @Published var ingridientsItems: [Views] = [.ingridientsList]
    
    @Published var sheetView: Views?
    @Published var modalView: Views?
    @Published var alert: Alerts?
}

enum Tabs: Hashable, Codable {
    
    case meals
    case dishes
    case ingridients
}

enum Views: Codable, Equatable, Hashable {
    
    // Explicitly implement encoding
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(makeCode())
    }
    
    // Explicitly implement decoding
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self = switch try container.decode(Codes.self) {
        case .mealsList:
                .mealsList
        case .mealEdit(let mealId):
                .mealEdit(mealId: mealId)
        case .mealDishEdit(let mealDishId):
                .mealDishEdit(mealDishId: mealDishId)
        case .mealIngridientEdit(ingridientId: let ingridientId):
                .mealIngridientEdit(ingridientId: ingridientId)
        case .dishList:
                .dishList
        case .dishCategoriesList:
                .dishCategoriesList
        case .dishEdit(let dishId):
                .dishEdit(dishId: dishId)
        case .dishPicklist(let type):
                .dishPicklist(type: type, filter: nil, completion: { _ in })
        case .dishCategoryPicklist(let type):
                .dishCategoryPicklist(type: type, filter: nil, completion: { _ in })
        case .dishIngridientsPicklist(let type):
                .dishIngridientsPicklist(type: type, filter: nil, completion: { _ in })
        case .dishCategoryEdit(let dishCategoryId):
                .dishCategoryEdit(dishCategoryId: dishCategoryId)
        case .ingridientsList:
                .ingridientsList
        case .ingridientCategoriesList:
                .ingridientCategoriesList
        case .ingridientEdit(let ingridientId):
                .ingridientEdit(ingridientId: ingridientId)
        case .ingridientCategoryPicklist(let type):
                .ingridientCategoryPicklist(type: type, filter: nil, completion: { _ in })
        case .ingridientCategoryEdit(let categoryId):
                .ingridientCategoryEdit(categoryId: categoryId)
        }
    }
    
    private func makeCode() -> Codes {
        switch self {
        case .mealsList:
            Codes.mealsList
        case .mealEdit(let mealId):
            Codes.mealEdit(mealId: mealId)
        case .mealDishEdit(let mealDishId):
            Codes.mealDishEdit(mealDishId: mealDishId)
        case .mealIngridientEdit(ingridientId: let ingridientId):
            Codes.mealIngridientEdit(ingridientId: ingridientId)
        case .dishList:
            Codes.dishList
        case .dishCategoriesList:
            Codes.dishCategoriesList
        case .dishEdit(let dishId):
            Codes.dishEdit(dishId: dishId)
        case .dishPicklist(let type, _, _):
            Codes.dishPicklist(type: type)
        case .dishCategoryPicklist(let type, _, _):
            Codes.dishCategoryPicklist(type: type)
        case .dishIngridientsPicklist(let type, _, _):
            Codes.dishIngridientsPicklist(type: type)
        case .dishCategoryEdit(dishCategoryId: let dishCategoryId):
            Codes.dishCategoryEdit(dishCategoryId: dishCategoryId)
        case .ingridientsList:
            Codes.ingridientsList
        case .ingridientCategoriesList:
            Codes.ingridientCategoriesList
        case .ingridientEdit(let ingridientId):
            Codes.ingridientEdit(ingridientId: ingridientId)
        case .ingridientCategoryPicklist(let type, _, _):
            Codes.ingridientCategoryPicklist(type: type)
        case .ingridientCategoryEdit(let categoryId):
            Codes.ingridientCategoryEdit(categoryId: categoryId)
        }
    }
    
     enum Codes: Codable, Hashable {
         case mealsList
         case mealEdit(mealId: UUID?)
         case mealDishEdit(mealDishId: UUID?)
         case mealIngridientEdit(ingridientId: UUID?)
         case dishList
         case dishCategoriesList
         case dishEdit(dishId: UUID?)
         case dishPicklist(type: PicklistType)
         case dishCategoryPicklist(type: PicklistType)
         case dishIngridientsPicklist(type: PicklistType)
         case dishCategoryEdit(dishCategoryId: UUID?)
         case ingridientsList
         case ingridientCategoriesList
         case ingridientEdit(ingridientId: UUID?)
         case ingridientCategoryPicklist(type: PicklistType)
         case ingridientCategoryEdit(categoryId: UUID?)
     }
    
    static func == (lhs: Views, rhs: Views) -> Bool {
        lhs.makeCode() == rhs.makeCode()
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(makeCode())
    }
    
    case mealsList
    case mealEdit(mealId: UUID?)
    case mealDishEdit(mealDishId: UUID?)
    case mealIngridientEdit(ingridientId: UUID?)
    case dishList
    case dishCategoriesList
    case dishEdit(dishId: UUID?)
    case dishPicklist(type: PicklistType, filter: Predicate?, completion: (Set<UUID>) -> Void)
    case dishCategoryPicklist(type: PicklistType, filter: Predicate?, completion: (Set<UUID>) -> Void)
    case dishIngridientsPicklist(type: PicklistType, filter: Predicate?, completion: (Set<UUID>) -> Void)
    case dishCategoryEdit(dishCategoryId: UUID?)
    case ingridientsList
    case ingridientCategoriesList
    case ingridientEdit(ingridientId: UUID?)
    case ingridientCategoryPicklist(type: PicklistType, filter: Predicate?, completion: (Set<UUID>) -> Void)
    case ingridientCategoryEdit(categoryId: UUID?)
    
    var stringKey: String {
        switch self {
        case .mealsList:
            "mealsList"
        case .mealEdit:
            "mealEdit"
        case .mealDishEdit:
            "mealDishEdit"
        case .mealIngridientEdit:
            "mealIngridientEdit"
        case .dishList:
            "dishList"
        case .dishEdit:
            "dishEdit"
        case .dishPicklist:
            "dishPicklist"
        case .dishCategoryEdit:
            "dishCategoryEdit"
        case .dishCategoriesList:
            "dishCategoriesList"
        case .dishCategoryPicklist:
            "dishCategoryPicklist"
        case .dishIngridientsPicklist:
            "dishIngridientsPicklist"
        case .ingridientsList:
            "ingridientsList"
        case .ingridientCategoriesList:
            "ingridientCategoriesList"
        case .ingridientEdit:
            "ingridientEdit"
        case .ingridientCategoryPicklist:
            "ingridientCategoryPicklist"
        case .ingridientCategoryEdit:
            "ingridientCategoryEdit"
        }
    }
    
    func isTypeIn(_ views: [Views]) -> Bool {
        views.contains(where: { $0.stringKey == stringKey })
    }
}

enum Alerts: Equatable, Hashable {
    static func == (lhs: Alerts, rhs: Alerts) -> Bool {
        lhs.hashValue == rhs.hashValue
    }
    
    func hash(into hasher: inout Hasher) {
        switch self {
        case .confirmAlert:
            hasher.combine("confirmAlert")
        case .errorAlert:
            hasher.combine("errorAlert")
        }
    }
    
    case confirmAlert(messageKey: String, confirmAction: (() -> Void)?, cancelAction: (() -> Void)?)
    case errorAlert(messageKey: String)
}
