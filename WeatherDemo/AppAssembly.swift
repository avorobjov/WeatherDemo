//
//  AppAssembly.swift
//  WeatherDemo
//
//  Created by Alexander Vorobjov on 1/17/21.
//

import Services
import Foundation

protocol AppAssembly {
    var weatherService: WeatherService { get }
    var iconsService: IconsService { get }
}

class AppAssemblyImpl {
    let session: URLSession
    let _iconsService = IconsServiceImpl()

    init() {
        session = URLSession(configuration: URLSessionConfiguration.default, delegate: nil, delegateQueue: .main)

        if
            let dataURL = Bundle.main.url(forResource: "Icons", withExtension: "json"),
            let data = try? Data(contentsOf: dataURL)
        {
            _iconsService.readIconsData(from: data)
        }
    }
}

extension AppAssemblyImpl: AppAssembly {
    var weatherService: WeatherService {
        WeatherServiceImpl(session: session)
    }

    var iconsService: IconsService {
        _iconsService
    }
}
