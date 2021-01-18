//
//  WeatherDemoUITests.swift
//  WeatherDemoUITests
//
//  Created by Alexander Vorobjov on 1/17/21.
//

import XCTest

class WeatherDemoUITests: XCTestCase {
    func testNavigationTitle() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        XCTAssert(app.navigationBars["main.navbar"].exists)
        XCTAssert(app.segmentedControls["picker.source"].exists)

        XCTAssert(app.navigationBars["main.navbar"].staticTexts["Munich, DE"].waitForExistence(timeout: 10))

        app.segmentedControls["picker.source"].buttons.element(boundBy: 1).tap()

        XCTAssert(app.navigationBars["main.navbar"].staticTexts["Minsk, BY"].waitForExistence(timeout: 10))

        app.segmentedControls["picker.source"].buttons.element(boundBy: 0).tap()

        XCTAssert(app.navigationBars["main.navbar"].staticTexts["Munich, DE"].waitForExistence(timeout: 10))
    }
}
