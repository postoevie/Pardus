//
//  CategoriesListViewState.swift
//  Pardus
//
//  Created by Igor Postoev on 23.7.24.
//  
//

import SwiftUI

final class CategoriesListViewState: ObservableObject, CategoriesListViewStateProtocol {
  
    @Published var sections: [CategoriesListSection] = []
    @Published var alertTitle: String = ""
    @Published var alertPresented: Bool = false
    @Published var navigationTitle: String = ""
    
    func set(sections: [CategoriesListSection]) {
        self.sections = sections
    }
    
    func showAlert(title: String) {
        self.alertTitle = title
        self.alertPresented = true
    }
    
    func hideAlert() {
        self.alertTitle = ""
        self.alertPresented = false
    }
    
    func setNavigationTitle(text: String) {
        navigationTitle = text
    }
}
