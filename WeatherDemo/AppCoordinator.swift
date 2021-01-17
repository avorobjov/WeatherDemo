//
//  AppCoordinator.swift
//  WeatherDemo
//
//  Created by Alexander Vorobjov on 1/17/21.
//

import UIKit

class AppCoordinator {
    private let assembly: AppAssembly
    private var navigation: UINavigationController?

    init(assembly: AppAssembly) {
        self.assembly = assembly
    }

    func start(in window: UIWindow) {
        let builder = MainBuilder(assembly: assembly)
        let home = builder.build()

        let nc = UINavigationController(rootViewController: home)
        nc.navigationBar.accessibilityIdentifier = "main.navbar"

        navigation = nc

        window.rootViewController = nc
    }
}
