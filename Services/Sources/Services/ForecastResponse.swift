//
//  File.swift
//  
//
//  Created by Alexander Vorobjov on 1/17/21.
//

import Foundation
import Entities

// swiftlint:disable nesting

struct ForecastResponse: Decodable {
    let list: [ListItem]
    let city: City

    struct ListItem: Decodable {
        let dt: Double
        let main: Main
        let weather: [Weather]
        let sys: Sys

        struct Main: Decodable {
            let temp: Double
        }

        struct Weather: Decodable {
            let id: Int
        }

        struct Sys: Decodable {
            let pod: String?
        }
    }

    struct City: Decodable {
        let name: String?
        let country: String?
        let timezone: Int
    }
}

// swiftlint:enable nesting

extension ForecastResponse {
    func toModel() -> Forecast {
        let cityComponents = [city.name, city.country].compactMap { $0 }
        let cityName = cityComponents.joined(separator: ", ")

        // swiftlint:disable:next force_unwrapping
        let timeZone = TimeZone(secondsFromGMT: city.timezone) ?? TimeZone(secondsFromGMT: 0)!

        let items = list.map { $0.toModel() }

        return Forecast(city: cityName, timeZone: timeZone, items: items)
    }
}

extension ForecastResponse.ListItem {
    func toModel() -> ForecastItem {
        let date = Date(timeIntervalSince1970: dt)
        let isDay = sys.pod == "d"

        return ForecastItem(date: date,
                            temperature: main.temp,
                            weatherConditionId: weather.first?.id ?? 0,
                            isDay: isDay)
    }
}
