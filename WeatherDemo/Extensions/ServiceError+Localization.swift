//
//  ServiceError+Localization.swift
//  WeatherDemo
//
//  Created by Alexander Vorobjov on 1/19/21.
//

import Services
import Foundation

extension ServiceError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .parseError:
            return "Failed to parse JSON data"

        case .loadError:
            return "Failed to load data"

        case .noInternetConnection:
            return "No internet connection"

        case .notFound:
            return "City not found"
        }
    }
}
