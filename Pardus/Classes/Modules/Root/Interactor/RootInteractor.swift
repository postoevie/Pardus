//
//  RootInteractor.swift
//  Pardus
//
//  Created by Igor Postoev on 2.12.24.
//  
//


import Foundation

final class RootInteractor: RootInteractorProtocol {
    
    let restoreRecordsService: RecordsRestoreServiceType
    
    init(restoreRecordsService: RecordsRestoreServiceType) {
        self.restoreRecordsService = restoreRecordsService
    }
    
    func restoreRecords() {
        guard let uiTestDataPath = EnvironmentUtils.uiTestsDataSnapshotPath,
              let uiTestData = FileManager.default.contents(atPath: uiTestDataPath),
              let snapshot = try? JSONDecoder().decode(RecordsStateSnapshot.self, from: uiTestData) else {
            return
        }
        restoreRecordsService.restoreRecords(snapshot: snapshot)
    }
}
