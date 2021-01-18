import XCTest
@testable import Entities

final class ForecastTests: XCTestCase {
    func testForecastItem() {
        let date = Date()
        let temp = 123.1123
        let weatherId = 123
        let itemDay = ForecastItem(date: date, temperature: temp, weatherConditionId: weatherId, isDay: true)
        XCTAssertEqual(itemDay.date.timeIntervalSince1970, date.timeIntervalSince1970)
        XCTAssertEqual(itemDay.temperature, temp)
        XCTAssertEqual(itemDay.weatherConditionId, weatherId)
        XCTAssertTrue(itemDay.isDay)

        let itemNight = ForecastItem(date: date, temperature: temp, weatherConditionId: weatherId, isDay: false)
        XCTAssertFalse(itemNight.isDay)
    }

    func testForecast() {
        let city = "test city"
        let tz = TimeZone.current
        let item1 = ForecastItem(date: Date(), temperature: 13, weatherConditionId: 321, isDay: true)
        let item2 = ForecastItem(date: Date(), temperature: 312, weatherConditionId: 23454, isDay: false)
        let fc = Forecast(city: city, timeZone: tz, items: [item1, item2])
        XCTAssertEqual(fc.city, city)
        XCTAssertEqual(fc.timeZone.secondsFromGMT(), tz.secondsFromGMT())
        XCTAssertEqual(fc.items.count, 2)
        XCTAssertEqual(fc.items[0].isDay, true)
        XCTAssertEqual(fc.items[1].isDay, false)
    }
}
