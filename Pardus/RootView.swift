//
//  RootView.swift
//  Pardus
//
//  Created by Igor Postoev on 11.5.24.
//
//

import SwiftUI

struct RootView: View {
    
    @ObservedObject var navigationService: NavigationService
    @ObservedObject var appViewBuilder: ApplicationViewBuilder
    
    var body: some View {
        TabView {
            NavigationStack(path: $navigationService.mealsItems) {
                Spacer()
                    .navigationDestination(for: Views.self) { path in
                        appViewBuilder.build(view: path)
                    }
            }
            .tabItem {
                Label("rootview.tabs.meals", systemImage: "")
            }
            .tag("meals")
            NavigationStack(path: $navigationService.dishesItems) {
                Spacer()
                    .navigationDestination(for: Views.self) { path in
                        appViewBuilder.build(view: path)
                    }
            }
            .tabItem {
                Label("rootview.tabs.dishes", systemImage: "")
            }
            .tag("dishes")
            NavigationStack(path: $navigationService.ingridientsItems) {
                Spacer()
                    .navigationDestination(for: Views.self) { path in
                        appViewBuilder.build(view: path)
                    }
            }
            .tabItem {
                Label("rootview.tabs.ingridients", systemImage: "")
            }
            .tag("ingridients")
        }
        .fullScreenCover(isPresented: .constant($navigationService.modalView.wrappedValue != nil)) {
            if let modal = navigationService.modalView {
                appViewBuilder.build(view: modal)
            }
        }
        .sheet(isPresented: .constant($navigationService.sheetView.wrappedValue != nil),
               onDismiss: { navigationService.sheetView = nil }) {
            if let sheet = navigationService.sheetView {
                appViewBuilder.build(view: sheet)
            }
        }
        .alert(isPresented: .constant($navigationService.alert.wrappedValue != nil)) {
            switch navigationService.alert {
            case .defaultAlert(let yesAction, let noAction):
                return Alert(title: Text("app.alert.acceptAction"),
                             primaryButton: .default(Text("app.yes"), action: yesAction),
                             secondaryButton: .destructive(Text("app.no"), action: noAction))
            case .none:
                fatalError()
            }
        }
    }
}
