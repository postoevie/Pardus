//
//  RootRouter.swift
//  Pardus
//
//  Created by Igor Postoev on 2.12.24.
//  
//

import Foundation

final class RootRouter: RootRouterProtocol {
    
    private let navigationService: any NavigationServiceType
    
    init(navigationService: any NavigationServiceType) {
        self.navigationService = navigationService
    }
    
    func showStartScreen() {
        if let snapshot = getViewSnapshot() {
            apply(snapshot: snapshot)
        }
    }
    
    private func getViewSnapshot() -> ViewsStateSnapshot? {
        getUITestSnapshot()
    }
    
    private func apply(snapshot: ViewsStateSnapshot) {
        navigationService.tab = snapshot.tab
        navigationService.mealsItems = snapshot.mealsItems
        navigationService.dishesItems = snapshot.dishesItems
        navigationService.ingridientsItems = snapshot.ingridientsItems
    }
    
    private func getUITestSnapshot() -> ViewsStateSnapshot? {
        guard let uiTestViewPath = EnvironmentUtils.uiTestsViewSnapshotPath,
              let uiTestData = FileManager.default.contents(atPath: uiTestViewPath),
              let snapshot = try? JSONDecoder().decode(ViewsStateSnapshot.self, from: uiTestData) else {
            return nil
        }
        return snapshot
    }
}
