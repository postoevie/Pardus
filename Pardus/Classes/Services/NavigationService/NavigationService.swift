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
    @Published var dishesItems: [Views] = [.dishesSectionsList]
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
    case dishList
    case dishEdit(dishId: UUID?)
    case picklist(callingView: Views, preselected: Set<UUID>, completion: (Set<UUID>) -> Void)
    case dishCategoryPick(callingView: Views, preselected: Set<UUID>, completion: (Set<UUID>) -> Void)
    case dishCategoryEdit(dishCategoryId: UUID?)
    case dishesSectionsList
    
    var stringKey: String {
        switch self {
        case .mealsList:
            return "mealsList"
        case .mealEdit:
            return "mealEditing"
        case .dishList:
            return "dishList"
        case .dishEdit:
            return "dishEdit"
        case .picklist:
            return "picklist"
        case .dishCategoryEdit:
            return "dishCategoryEdit"
        case .dishesSectionsList:
            return "dishesSectionsList"
        case .dishCategoryPick:
            return "dishCategoryPick"
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
