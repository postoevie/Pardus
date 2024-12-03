//
//  PardusUITests.swift
//  PardusUITests
//
//  Created by Igor Postoev on 30.11.24..
//

import XCTest
import Pardus

final class PardusUITests: XCTestCase {
    
    let dishesStates = [(UUID(), DishState(name: "Mashed potato", categoryId: nil)),
                        (UUID(), DishState(name: "Cabbage salad", categoryId: nil)),
                        (UUID(), DishState(name: "French fries", categoryId: nil)),
                        (UUID(), DishState(name: "Cake", categoryId: nil))]

    override func setUpWithError() throws {
        continueAfterFailure = false
        
        if let path = EnvironmentUtils.uiTestsViewSnapshotPath {
            let snapshot = ViewsStateSnapshot(tab: .dishes,
                                              mealsItems: [.mealsList],
                                              dishesItems: [.dishList],
                                              ingridientsItems: [.ingridientsList])
            let encoded = try JSONEncoder().encode(snapshot)
            FileManager.default.createFile(atPath: path, contents: encoded)
        }
        
        if let path = EnvironmentUtils.uiTestsDataSnapshotPath {
            let state = RecordsStateSnapshot(dishes: Dictionary(uniqueKeysWithValues: dishesStates),
                                             dishCategories: [:])
            let encoded = try JSONEncoder().encode(state)
            FileManager.default.createFile(atPath: path, contents: encoded)
        }
    }

    override func tearDownWithError() throws {
        if let filePath = EnvironmentUtils.uiTestsViewSnapshotPath {
            try FileManager.default.removeItem(atPath: filePath)
        }
        if let filePath = EnvironmentUtils.uiTestsDataSnapshotPath {
            try FileManager.default.removeItem(atPath: filePath)
        }
    }

    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launchArguments.append(Const.UITests.argumentKey)
        app.launchEnvironment[Const.UITests.viewSnapshotPathKey] = EnvironmentUtils.uiTestsViewSnapshotPath
        app.launchEnvironment[Const.UITests.dataSnapshotPathKey] = EnvironmentUtils.uiTestsDataSnapshotPath
        
        app.launch()
        _ = app.wait(for: .notRunning, timeout: 1)
        
        XCTAssert(app.navigationBars["Dishes"].exists)
        XCTAssert(app.textFields["searchlist.searchview"].exists)
        XCTAssert(app.collectionViews["searchlist.list"].exists)
        
        for dishState in dishesStates {
            XCTAssert(app.staticTexts["searchlist.cell.\(dishState.0).title"].exists)
            XCTAssert(app.staticTexts["searchlist.cell.\(dishState.0).title"].label == dishState.1.name)
        }
        
    }
}
