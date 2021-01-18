//
//  WeatherDemoTests.swift
//  WeatherDemoTests
//
//  Created by Alexander Vorobjov on 1/17/21.
//

import XCTest
@testable import WeatherDemo
import Entities
import Services

class WeatherDemoTests: XCTestCase {
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testWeatherIcons() throws {
        let assembly = AppAssemblyImpl()
        let iconsService = assembly._iconsService
        for weatherId in iconsService.allWeatherConditionIds {
            let nameDay = iconsService.iconName(for: ForecastItem(date: Date(), temperature: 123, weatherConditionId: weatherId, isDay: true))
            XCTAssertNotNil(nameDay)
            XCTAssertNotNil(UIImage(named: nameDay!))

            let nameNight = iconsService.iconName(for: ForecastItem(date: Date(), temperature: 123, weatherConditionId: weatherId, isDay: false))
            XCTAssertNotNil(nameNight)
            XCTAssertNotNil(UIImage(named: nameNight!))
        }
    }
}
