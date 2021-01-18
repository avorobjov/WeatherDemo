//
//  MainViewController.swift
//  WeatherDemo
//
//  Created by Alexander Vorobjov on 1/17/21.
//

import UIKit

final class MainViewController: UIViewController {
    @IBOutlet private var sourcePicker: UISegmentedControl!
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

        sourcePicker.accessibilityIdentifier = "picker.source"

        presenter.view = self
    }

    @IBAction private func onSourceChanged() {
        presenter.selectSource(at: sourcePicker.selectedSegmentIndex)
    }
}

extension MainViewController: MainView {
    func show(forecast: ForecastViewModel?) {
        forecastView.viewModel = forecast
    }

    func show(sources: [String], selectedIndex: Int) {
        if sourcePicker.numberOfSegments != sources.count {
            sourcePicker.removeAllSegments()
            for (index, title) in sources.enumerated() {
                sourcePicker.insertSegment(withTitle: title, at: index, animated: false)
            }
        }
        else {
            for (index, title) in sources.enumerated() {
                sourcePicker.setTitle(title, forSegmentAt: index)
            }
        }
    }
}

private extension MainViewController {
}
