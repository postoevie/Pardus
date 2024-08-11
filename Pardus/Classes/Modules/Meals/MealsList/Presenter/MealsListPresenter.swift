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
        viewState?.set(sections: makeSortedSections(models: interactor.mealModels))
    }
    
    func setStartDate(_ date: Date) {
        interactor.startDate = date
        viewState?.set(sections: makeSortedSections(models: interactor.mealModels))
    }
    
    func setEndDate(_ date: Date) {
        interactor.endDate = date
        viewState?.set(sections: makeSortedSections(models: interactor.mealModels))
    }
    
    func tapAddNewItem() {
        router.showAdd()
    }
    
    func deleteitem(uid: UUID) {
        Task {
            do {
                try await interactor.delete(itemId: uid)
                try await interactor.loadMeals()
                await MainActor.run {
                    viewState?.set(sections: makeSortedSections(models: interactor.mealModels))
                }
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
            await MainActor.run {
                viewState?.set(sections: makeSortedSections(models: interactor.mealModels))
            }
        }
    }
    
    private func makeSortedSections(models: [MealModel]) -> [MealsListSection] {
        let sortedModels = models.sorted { $0.date > $1.date }
        var sections = [MealsListSection]()
        for model in sortedModels {
            let date = model.date
            let dateString = sectionDateFormatter.string(from: date)
            if let lastSection = sections.last,
               dateString == lastSection.title {
                _ = sections.removeLast()
                sections.append(MealsListSection(title: dateString,
                                                 items: lastSection.items + [mapToItem(model: model)]))
                continue
            }
            sections.append(MealsListSection(title: dateString,
                                             items: [mapToItem(model: model)]))
        }
        return sections
    }
    
    private func mapToItem(model: MealModel) -> MealsListItem {
        MealsListItem(id: model.id,
                      title: itemDateFormatter.string(from: model.date),
                      subtitle: model.dishes.map { $0.name }.joined(separator: "; "))
    }
}
