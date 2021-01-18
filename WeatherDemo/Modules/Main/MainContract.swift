//
//  MainContract.swift
//  WeatherDemo
//
//  Created by Alexander Vorobjov on 1/17/21.
//

import Foundation

protocol MainPresenter: Presenter {
    var view: MainView? { get set }

    func selectSource(at index: Int)
}

protocol MainView: View, MessagePresenting, TitleSettable {
    func show(forecast: ForecastViewModel?)
    func show(sources: [String], selectedIndex: Int)
}
