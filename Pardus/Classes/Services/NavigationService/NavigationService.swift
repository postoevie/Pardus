//
//  NavigationService.swift
//  Pardus
//
//  Created by Igor Postoev on 11.5.24.
//  
//


import SwiftUI
import Combine

public class NavigationService: NavigationServiceType  {
    
    public let id = UUID()
    
    public static func == (lhs: NavigationService, rhs: NavigationService) -> Bool {
        lhs.id == rhs.id
    }
    
    @Published var modalView: Views?
    @Published var items: [Views] = [.dishesSectionsList]
    @Published var alert: CustomAlert?
    @Published var selectedTab: String = "Dishes"
    
    var itemsPublisher: Published<[Views]>.Publisher {
        $items
    }
    
    private var subscription: AnyCancellable?
    
    init() {
        subscription = $selectedTab.sink { output in
            if output == "Dishes" {
                self.items = [.dishesSectionsList]
            }
            if output == "Meals" {
                self.items = [.mealsList]
            }
        }
    }
}


indirect enum Views: Equatable, Hashable {
    
    static func == (lhs: Views, rhs: Views) -> Bool {
        lhs.stringKey == rhs.stringKey
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.stringKey)
    }
    
    case main
    case mealsList
    case mealEdit(mealId: UUID?)
    case dishList
    case dishEdit(dishId: UUID?)
    case dishesPick(callingView: Views, preselectedDishes: [UUID], completion: ([UUID]) -> Void)
    case dishCategoryEdit(dishCategoryId: UUID?)
    case dishesSectionsList
    
    var stringKey: String {
        switch self {
        case .main:
            return "main"
        case .mealsList:
            return "mealsList"
        case .mealEdit:
            return "mealEditing"
        case .dishList:
            return "dishList"
        case .dishEdit:
            return "dishEdit"
        case .dishesPick:
            return "dishesPick"
        case .dishCategoryEdit:
            return "dishCategoryEdit"
        case .dishesSectionsList:
            return "dishesSectionsList"
        }
    }
}

class StubNavigation: NavigationServiceType, ObservableObject, Equatable  {
    @Published var modalView: Views?
    @Published var alert: CustomAlert?
    
    public let id = UUID()
    
    public static func == (lhs: StubNavigation, rhs: StubNavigation) -> Bool {
        lhs.id == rhs.id
    }
    
    fileprivate init() {}
    
    static var stub: any NavigationServiceType { NavigationService() }
    
    @Published var items: [Views] = []
    
    var itemsPublisher: Published<[Views]>.Publisher {
        $items
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
