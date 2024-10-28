//
//  MealsListContracts.swift
//  Pardus
//
//  Created by Igor Postoev on 18.5.24.
//  
//

import SwiftUI


// Router
protocol MealsListRouterProtocol: RouterProtocol {
    
    func showAdd()
    func showEdit(mealId: UUID)
}

// Presenter
protocol MealsListPresenterProtocol: PresenterProtocol {
    
    func tapAddNewItem()
    func tapToggleDateFilter()
    func setStartDate(_ date: Date)
    func setEndDate(_ date: Date)
    func didAppear()
    func deleteitem(uid: UUID)
    func tapItem(uid: UUID)
}

// Interactor
protocol MealsListInteractorProtocol: InteractorProtocol {
    func performWithMeals(action: @escaping ([Meal]) -> Void) async throws
    var startDate: Date { get set }
    var endDate: Date { get set }
    var dateFilterEnabled: Bool { get set }
    func loadMeals() async throws
    func delete(itemId: UUID) async throws
}

// ViewState
protocol MealsListViewStateProtocol: ViewStateProtocol {
    func set(sections: [MealsListSection])
    func setStartDateVisible(_ visible: Bool)
}
