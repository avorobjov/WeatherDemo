//
//  MainPresenter.swift
//  WeatherDemo
//
//  Created by Alexander Vorobjov on 1/17/21.
//

import Foundation
import UIKit.UIImage

final class MainPresenterImpl {
    weak var view: MainView? {
        didSet {
            viewDidAttach()
        }
    }

    var iconsData = [Int: String]()

    init() {
        iconsData = readIconsData()
    }

    func viewDidAttach() {
        view?.set(title: "Test")
        showTestData()
    }
}

extension MainPresenterImpl: MainPresenter {
    func showTestData() {
        let headerColumns: [ForecastViewModel.Cell] = stride(from: 0, to: 23, by: 3).map { .header(title: "\($0):00", alignment: .center) }
        let header: [ForecastViewModel.Cell] = [.header(title: "", alignment: .left)] + headerColumns

        var line1: [ForecastViewModel.Cell] = [.header(title: "Monday", alignment: .left)]
        for _ in headerColumns.indices {
            let temp = Int.random(in: -20...20)
            let imageName = iconsData.values.randomElement() ?? "wi-na"
            line1.append(.value(temp: "\(temp)", image: UIImage(named: imageName)))
        }

        var line2: [ForecastViewModel.Cell] = [.header(title: "Tuesday", alignment: .left)]
        for _ in headerColumns.indices {
            let temp = Int.random(in: -20...20)
            let imageName = iconsData.values.randomElement() ?? "wi-na"
            line2.append(.value(temp: "\(temp)", image: UIImage(named: imageName)))
        }

        let vm = ForecastViewModel(items: [header, line1, line2])

        view?.show(forecast: vm)
    }

    func readIconsData() -> [Int: String] {
        guard
            let dataURL = Bundle.main.url(forResource: "Icons", withExtension: "json"),
            let data = try? Data(contentsOf: dataURL),
            let rawIconsData = try? JSONDecoder().decode([String: IconData].self, from: data)
        else {
            return [:]
        }

        var result = [Int: String]()

        for (k, v) in rawIconsData {
            guard let intKey = Int(k) else {
                print("readIconsData: bad key")
                continue
            }

            result[intKey] = "wi-\(v.icon)"
        }

        return result
    }
}

class IconData: Decodable {
    let icon: String
}
