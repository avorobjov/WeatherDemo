//
//  IconsServiceTests.swift
//  
//
//  Created by Alexander Vorobjov on 1/19/21.
//

import XCTest
import Entities
@testable import Services

final class IconsServiceTests: XCTestCase {
    func testNames() {
        let json = """
{"801":{"label":"few clouds","icon":"few_clouds"},"802":{"label":"scattered clouds","icon":"scattered_clouds"}}
"""

        let service = IconsServiceImpl()
        service.readIconsData(from: json.data(using: .utf8)!)

        XCTAssertEqual(service.allWeatherConditionIds.count, 2)

        // 801
        XCTAssertEqual(service.iconName(for: makeItem(id: 801, isDay: true)), "wi-day-few_clouds")
        XCTAssertEqual(service.iconName(for: makeItem(id: 801, isDay: false)), "wi-night-few_clouds")

        // 802
        XCTAssertEqual(service.iconName(for: makeItem(id: 802, isDay: true)), "wi-day-scattered_clouds")
        XCTAssertEqual(service.iconName(for: makeItem(id: 802, isDay: false)), "wi-night-scattered_clouds")

        // other
        XCTAssertNil(service.iconName(for: makeItem(id: 12312, isDay: true)))
        XCTAssertNil(service.iconName(for: makeItem(id: 12341, isDay: false)))
    }

    func makeItem(id: Int, isDay: Bool) -> ForecastItem {
        return ForecastItem(date: Date(), temperature: 0, weatherConditionId: id, isDay: isDay)
    }
}
