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
    @Published var alert: CustomAlert?
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
        return switch self {
        case .mealsList:
            Codes.mealsList
        case .mealEdit(let mealId):
            Codes.mealEdit(mealId: mealId)
        case .mealDishEdit(let mealDishId):
            Codes.mealDishEdit(mealDishId: mealDishId)
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
    
    case defaultAlert(yesAction: (() -> Void)?, noAction: (() -> Void)?)
}
