//
//  MealsListPresenter.swift
//  Pardus
//
//  Created by Igor Postoev on 18.5.24.
//  
//

import SwiftUI

final class MealsListPresenter: ObservableObject, MealsListPresenterProtocol {
    
    private let router: MealsListRouterProtocol
    private weak var viewState: MealsListViewStateProtocol?
    private let interactor: MealsListInteractorProtocol
    
    let sectionDateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()
    
    let itemDateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        return formatter
    }()
    
    init(router: MealsListRouterProtocol,
         interactor: MealsListInteractorProtocol,
         viewState: MealsListViewStateProtocol) {
        self.router = router
        self.interactor = interactor
        self.viewState = viewState
    }
    
    func tapToggleDateFilter() {
        interactor.dateFilterEnabled.toggle()
        viewState?.setStartDateVisible(interactor.dateFilterEnabled)
        updateViewState()
    }
    
    func setStartDate(_ date: Date) {
        interactor.startDate = date
        updateViewState()
    }
    
    func setEndDate(_ date: Date) {
        interactor.endDate = date
        updateViewState()
    }
    
    func tapAddNewItem() {
        router.showAdd()
    }
    
    func deleteItem(uid: UUID) {
        Task {
            do {
                try await interactor.delete(itemId: uid)
                updateViewState()
            } catch {
                print(error)
            }
        }
    }
    
    func tapItem(uid: UUID) {
        router.showEdit(mealId: uid)
    }
    
    func didAppear() {
        Task {
            try await interactor.loadMeals()
            updateViewState()
        }
    }
    
    private func updateViewState() {
        Task {
            try await interactor.performWithMeals { meals in
                let sections = self.makeSortedSections(meals: meals)
                DispatchQueue.main.async {
                    self.viewState?.set(sections: sections)
                }
            }
        }
    }
    
    private func makeSortedSections(meals: [Meal]) -> [MealsListSection] {
        let sortedMeals = meals.sorted { $0.date > $1.date }
        var sections = [MealsListSection]()
        for meal in sortedMeals {
            let date = meal.date
            let dateString = sectionDateFormatter.string(from: date)
            if let lastSection = sections.last,
               dateString == lastSection.title {
                _ = sections.removeLast()
                sections.append(MealsListSection(title: dateString,
                                                 items: lastSection.items + [mapToItem(meal: meal)]))
                continue
            }
            sections.append(MealsListSection(title: dateString,
                                             items: [mapToItem(meal: meal)]))
        }
        return sections
    }
    
    private func mapToItem(meal: Meal) -> MealsListItem {
        MealsListItem(id: meal.id,
                      title: itemDateFormatter.string(from: meal.date),
                      subtitle: (meal.dishes).map { $0.dish.name }.joined(separator: ", "))
    }
}
