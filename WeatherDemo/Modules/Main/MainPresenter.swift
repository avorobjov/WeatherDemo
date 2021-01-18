//
//  MainPresenter.swift
//  WeatherDemo
//
//  Created by Alexander Vorobjov on 1/17/21.
//

import Foundation
import UIKit.UIImage
import Services
import Entities

final class MainPresenterImpl {
    private enum Source: CaseIterable {
        case live
        case json

        var title: String {
            switch self {
            case .live:
                return "München (Live)"

            case .json:
                return "Minsk (JSON)"
            }
        }
    }

    weak var view: MainView? {
        didSet {
            viewDidAttach()
        }
    }

    private let weatherService: WeatherService
    private let iconsService: IconsService

    private var selectedSource = Source.live {
        didSet {
            updateForecastData()
        }
    }

    private var dateFormatter: DateFormatter {
        let weekDayFormat = DateFormatter.dateFormat(fromTemplate: "EEEE", options: 0, locale: Locale.current)
        let dateFormat = DateFormatter.dateFormat(fromTemplate: "dMMMYYYY", options: 0, locale: Locale.current)

        let formatComponents = [weekDayFormat, dateFormat].compactMap { $0 }

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = formatComponents.joined(separator: "\n")
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = Locale.current
        return dateFormatter
    }

    private var timeFormatter: DateFormatter {
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "jm", options: 0, locale: Locale.current)
        timeFormatter.timeZone = TimeZone.current
        timeFormatter.locale = Locale.current
        return timeFormatter
    }

    private var temperatureFormatter: MeasurementFormatter {
        let formatter = MeasurementFormatter()
        formatter.locale = Locale.current
        formatter.unitOptions = .providedUnit
        formatter.numberFormatter.maximumFractionDigits = 0
        formatter.numberFormatter.roundingMode = .halfUp
        return formatter
    }

    init(weatherService: WeatherService, iconsService: IconsService) {
        self.weatherService = weatherService
        self.iconsService = iconsService
    }

    func viewDidAttach() {
        view?.set(title: "Loading")

        updateSources()
        updateForecastData()
    }
}

extension MainPresenterImpl: MainPresenter {
    func selectSource(at index: Int) {
        guard index < Source.allCases.count else {
            return
        }

        selectedSource = Source.allCases[index]
        updateSources()
        updateForecastData()
    }
}

private extension MainPresenterImpl {
    func updateSources() {
        let titles = Source.allCases.map { $0.title }
        let selectedIndex = Source.allCases.firstIndex(of: selectedSource) ?? 0

        view?.show(sources: titles, selectedIndex: selectedIndex)
    }

    func updateForecastData() {
        switch selectedSource {
        case .live:
            showLiveData()

        case .json:
            showJsonData()
        }
    }

    func showLiveData() {
        weatherService.loadForecastData(query: "München,de") { [weak self] result in
            do {
                self?.show(forecast: try result.get())
            }
            catch {
                self?.show(error: error)
            }
        }
    }

    func showJsonData() {
        do {
            guard
                let dataURL = Bundle.main.url(forResource: "Response", withExtension: "json")
            else {
                throw ServiceError.loadError
            }

            let data = try Data(contentsOf: dataURL)
            let result = weatherService.readCachedForecast(data: data)
            show(forecast: try result.get())
        }
        catch {
            show(error: error)
        }
    }

    func show(error: Error) {
        view?.presentMessage(title: "Error", message: error.localizedDescription)
        view?.show(forecast: nil)
    }

    func show(forecast: Forecast?) {
        guard let forecast = forecast else {
            view?.show(forecast: nil)
            return
        }

        // format items
        let items = formatForecastItems(forecast: forecast)

        // collect column headers
        var rows = [String]()
        var cols = [Int: String]()

        for item in items {
            if !rows.contains(item.date) {
                rows.append(item.date)
            }

            if cols[item.hours] == nil {
                cols[item.hours] = item.time
            }
        }

        // add header
        var header = [ForecastViewModel.Cell]()
        header.append(.header(title: "", alignment: .left))

        let columnHours = cols.keys.sorted(by: <)
        for hour in columnHours {
            let title = cols[hour] ?? ""
            header.append(.header(title: title, alignment: .center))
        }

        // create empty table
        var rowsData = [[ForecastViewModel.Cell]]()
        for title in rows {
            var row = [ForecastViewModel.Cell]()
            row.append(.header(title: title, alignment: .left))

            for _ in cols {
                row.append(.value(temp: "", image: nil))
            }

            rowsData.append(row)
        }

        // add real data
        for item in items {
            guard
                let rowIndex = rows.firstIndex(of: item.date),
                let colIndex = columnHours.firstIndex(of: item.hours)
            else {
                print("can't find row or column index")
                continue
            }

            rowsData[rowIndex][1 + colIndex] = .value(temp: item.temperature, image: item.icon)
        }

        view?.set(title: forecast.city)
        view?.show(forecast: ForecastViewModel(items: [header] + rowsData))
    }

    func formatForecastItems(forecast: Forecast) -> [FormattedForecastItem] {
        let dateFormatter = self.dateFormatter
        dateFormatter.timeZone = forecast.timeZone

        let timeFormatter = self.timeFormatter
        timeFormatter.timeZone = forecast.timeZone

        let temperatureFormatter = self.temperatureFormatter

        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = forecast.timeZone

        var result = [FormattedForecastItem]()

        let sortedItems = forecast.items.sorted { $0.date < $1.date }
        for item in sortedItems {
            let hours = calendar.component(.hour, from: item.date)
            let date = dateFormatter.string(from: item.date)
            let time = timeFormatter.string(from: item.date)
            let iconName = iconsService.iconName(for: item)
            let icon = iconName.flatMap { UIImage(named: $0) }
            let temp = temperatureFormatter.string(from: Measurement(value: item.temperature, unit: UnitTemperature.celsius))

            result.append(FormattedForecastItem(
                            hours: hours,
                            date: date,
                            time: time,
                            icon: icon,
                            temperature: temp))
        }

        return result
    }
}

struct FormattedForecastItem {
    let hours: Int
    let date: String
    let time: String
    let icon: UIImage?
    let temperature: String
}
