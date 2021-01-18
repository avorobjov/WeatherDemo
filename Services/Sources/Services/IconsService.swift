//
//  File.swift
//  
//
//  Created by Alexander Vorobjov on 1/18/21.
//

import Entities
import Foundation

public protocol IconsService {
    func iconName(for item: ForecastItem) -> String?
}

class IconData: Decodable {
    let icon: String
}

public class IconsServiceImpl {
    private var iconsData = [Int: String]()

    public var allWeatherConditionIds: [Int] {
        return Array(iconsData.keys)
    }

    public init() {
    }

    public func readIconsData(from data: Data) {
        guard
            let rawIconsData = try? JSONDecoder().decode([String: IconData].self, from: data)
        else {
            iconsData = [:]
            return
        }

        var result = [Int: String]()

        for (k, v) in rawIconsData {
            guard let intKey = Int(k) else {
                print("readIconsData: bad key")
                continue
            }

            result[intKey] = v.icon
        }

        iconsData = result
    }
}

extension IconsServiceImpl: IconsService {
    public func iconName(for item: ForecastItem) -> String? {
        // exception
        if item.weatherConditionId == 800 || item.weatherConditionId == 951 {
            return item.isDay ? "wi-day-sunny" : "wi-night-clear"
        }

        guard let name = iconsData[item.weatherConditionId] else {
            return nil
        }

        if [711, 721, 761, 762, 771, 781, 900, 901, 902, 903, 904, 905].contains(item.weatherConditionId) {
            return "wi-\(name)"
        }

        let day = item.isDay ? "day" : "night"
        return "wi-\(day)-\(name)"
    }
}
