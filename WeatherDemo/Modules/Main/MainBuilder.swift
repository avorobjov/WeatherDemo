//
//  MainBuilder.swift
//  WeatherDemo
//
//  Created by Alexander Vorobjov on 1/17/21.
//

import UIKit

struct MainBuilder {
    let assembly: AppAssembly

    func build() -> UIViewController {
        let presenter = MainPresenterImpl(
            weatherService: assembly.weatherService,
            iconsService: assembly.iconsService)
        return MainViewController(presenter: presenter)
    }
}
