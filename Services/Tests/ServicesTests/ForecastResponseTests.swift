import XCTest
@testable import Services

final class ForecastResponseTests: XCTestCase {
    func testCity() {
        let tz = 60*60*4    // 4h, it's not possible to create a timezone with arbitrary secondsFromGMT
        let city = ForecastResponse.City(name: "name", country: "country", timezone: tz)
        let response = ForecastResponse(list: [], city: city)
        let model = response.toModel()

        XCTAssertEqual(model.city, "name, country")
        XCTAssertEqual(model.timeZone.secondsFromGMT(), tz)
    }

    func testBadCity() {
        let tz = 60*60*7
        let onlyCountry = ForecastResponse.City(name: nil, country: "country", timezone: tz)
        let onlyCountryResponse = ForecastResponse(list: [], city: onlyCountry)
        let onlyCountryModel = onlyCountryResponse.toModel()

        XCTAssertEqual(onlyCountryModel.city, "country")
        XCTAssertEqual(onlyCountryModel.timeZone.secondsFromGMT(), tz)

        let onlyName = ForecastResponse.City(name: "name", country: nil, timezone: tz)
        let onlyNameResponse = ForecastResponse(list: [], city: onlyName)
        let onlyNameModel = onlyNameResponse.toModel()

        XCTAssertEqual(onlyNameModel.city, "name")

        let nothing = ForecastResponse.City(name: nil, country: nil, timezone: tz)
        let nothingResponse = ForecastResponse(list: [], city: nothing)
        let nothingModel = nothingResponse.toModel()

        XCTAssertEqual(nothingModel.city, "")
    }

    func testListItemDay() {
        let date = Date()
        let temp = 12.2
        let weatherId = 112

        let item = ForecastResponse.ListItem(
            dt: date.timeIntervalSince1970,
            main: ForecastResponse.ListItem.Main(temp: temp),
            weather: [ForecastResponse.ListItem.Weather(id: weatherId)],
            sys: ForecastResponse.ListItem.Sys(pod: "d"))
        let model = item.toModel()

        XCTAssertEqual(model.date.timeIntervalSince1970, date.timeIntervalSince1970)
        XCTAssertEqual(model.temperature, temp)
        XCTAssertEqual(model.weatherConditionId, weatherId)
        XCTAssertTrue(model.isDay)
    }

    func testListItemNight() {
        let date = Date()
        let temp = -1.2435
        let weatherId = 25

        let item = ForecastResponse.ListItem(
            dt: date.timeIntervalSince1970,
            main: ForecastResponse.ListItem.Main(temp: temp),
            weather: [ForecastResponse.ListItem.Weather(id: weatherId)],
            sys: ForecastResponse.ListItem.Sys(pod: "n"))
        let model = item.toModel()

        XCTAssertEqual(model.date.timeIntervalSince1970, date.timeIntervalSince1970)
        XCTAssertEqual(model.temperature, temp)
        XCTAssertEqual(model.weatherConditionId, weatherId)
        XCTAssertFalse(model.isDay)
    }
}
