//
//  RootView.swift
//  Pardus
//
//  Created by Igor Postoev on 11.5.24.
//  
//

import SwiftUI

struct MealsBasementView: View {
    @ObservedObject var navigationService: NavigationService
    
    var body: some View {
        Spacer()
            .onAppear {
                navigationService.items.append(.mealsList)
            }
    }
}

struct DishesBasementView: View {
    @ObservedObject var navigationService: NavigationService
    
    var body: some View {
        Spacer()
            .onAppear {
                navigationService.items.append(.dishList)
            }
    }
}

struct RootView: View {
    
    @ObservedObject var navigationService: NavigationService
    @ObservedObject var appViewBuilder: ApplicationViewBuilder
    
    var body: some View {

        TabView(selection: $navigationService.selectedTab) {
            NavigationStack(path: $navigationService.items) {
                Spacer()
                    .navigationDestination(for: Views.self) { path in
                        if navigationService.items.contains(.mealsList) {
                            appViewBuilder.build(view: path)
                        } else {
                            Spacer()
                        }
                    }
            }
            .tabItem {
                Label("Meals", systemImage: "")
            }
            .tag("Meals")
            NavigationStack(path: $navigationService.items) {
                Spacer()
                    .navigationDestination(for: Views.self) { path in
                        if navigationService.items.contains(.dishList) {
                            appViewBuilder.build(view: path)
                        } else {
                            Spacer()
                        }
                    }
            }
            .tabItem {
                Label("Dishes", systemImage: "")
            }
            .tag("Dishes")
        }
        .fullScreenCover(isPresented: .constant($navigationService.modalView.wrappedValue != nil)) {
            if let modal = navigationService.modalView {
                appViewBuilder.build(view: modal)
            }
        }
        .alert(isPresented: .constant($navigationService.alert.wrappedValue != nil)) {
            switch navigationService.alert {
            case .defaultAlert(let yesAction, let noAction):
                return Alert(title: Text("Title"),
                             primaryButton: .default(Text("Yes"), action: yesAction),
                             secondaryButton: .destructive(Text("No"), action: noAction))
            case .none:
                fatalError()
            }
        }
    }
}
