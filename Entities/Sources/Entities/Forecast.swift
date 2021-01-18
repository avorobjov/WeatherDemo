import Foundation

public struct Forecast {
    public let city: String
    public let timeZone: TimeZone
    public let items: [ForecastItem]

    public init(city: String, timeZone: TimeZone, items: [ForecastItem]) {
        self.city = city
        self.timeZone = timeZone
        self.items = items
    }
}

public struct ForecastItem {
    public let date: Date
    public let temperature: Double
    public let weatherConditionId: Int
    public let isDay: Bool

    public init(date: Date, temperature: Double, weatherConditionId: Int, isDay: Bool) {
        self.date = date
        self.temperature = temperature
        self.weatherConditionId = weatherConditionId
        self.isDay = isDay
    }
}
