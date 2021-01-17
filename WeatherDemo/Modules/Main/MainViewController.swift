//
//  MainViewController.swift
//  WeatherDemo
//
//  Created by Alexander Vorobjov on 1/17/21.
//

import UIKit

final class MainViewController: UIViewController {
    static let margin: CGFloat = 10

    @IBOutlet private var forecastView: ForecastView!

    private let presenter: MainPresenter

    init(presenter: MainPresenter) {
        self.presenter = presenter

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground

        presenter.view = self
    }
}

extension MainViewController: MainView {
    func show(forecast: ForecastViewModel) {
        forecastView.viewModel = forecast
    }
}

private extension MainViewController {
}
