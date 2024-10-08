//
//  MealsListViewState.swift
//  Pardus
//
//  Created by Igor Postoev on 18.5.24.
//  
//

import SwiftUI
import Combine

final class MealsListViewState: ObservableObject, MealsListViewStateProtocol {
    
    @Published var sections: [MealsListSection] = []
    @Published var startDate: Date = Date()
    @Published var endDate: Date = Date()
    @Published var dateSelectionVisible = false
    
    private var presenter: MealsListPresenterProtocol?
    private var subscriptions: [AnyCancellable] = []
    
    func set(sections: [MealsListSection]) {
        self.sections = sections
    }
    
    func set(presenter: MealsListPresenterProtocol) {
        guard self.presenter == nil else {
            assertionFailure("Set presenter once")
            return
        }
        self.presenter = presenter
        $startDate
            .sink {
                self.presenter?.setStartDate($0)
            }.store(in: &subscriptions)
        $endDate
            .sink {
                self.presenter?.setEndDate($0)
            }.store(in: &subscriptions)
    }
    
    func setStartDateVisible(_ visible: Bool) {
        dateSelectionVisible = visible
    }
}

struct MealsListSection {
    
    let title: String
    let items: [MealsListItem]
}

struct MealsListItem: Identifiable {
    
    let id: UUID
    let title: String
    let subtitle: String
}
