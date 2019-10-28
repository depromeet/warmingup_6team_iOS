//
//  HomePresenter.swift
//  WePet
//
//  Created by hb1love on 2019/10/26.
//  Copyright © 2019 depromeet. All rights reserved.
//

import Foundation

protocol HomePresenterType {
    var spots: [Spot] { get }
    var selectedCategory: Category { get }

    func didVisit(_ location: Location)
    func didSelectCategory(_ category: Category)
}

final class HomePresenter: HomePresenterType {
    private weak var view: HomeViewControllerType?
    private var mapService: MapServiceType
    private var weatherService: WeatherServiceType

    private(set) var spots: [Spot] = []
    private(set) var selectedCategory: Category = .favorite
    private var isLoaded = false

    init(
        view: HomeViewControllerType,
        mapService: MapServiceType,
        weatherService: WeatherServiceType
    ) {
        self.view = view
        self.mapService = mapService
        self.weatherService = weatherService
    }
}

extension HomePresenter {
    func didVisit(_ location: Location) {
        if isLoaded { return }
        isLoaded = true
        weatherService.weather(location: location) { [weak self] result in
            guard let `self` = self else { return }
            switch result {
            case .success(let weather):
                self.selectedCategory = weather.type?.recommendCategory ?? .cafe
                self.fetchSpots()
                DispatchQueue.main.async {
                    self.view?.configureWeather(weather)
                    self.view?.configureCategory(self.selectedCategory)
                }
            case .failure(let error):
                log.warning(error)
            }
        }
    }

    func didSelectCategory(_ category: Category) {
        self.selectedCategory = category
        fetchSpots()
    }
}

private extension HomePresenter {
    func fetchSpots() {
        mapService.getSpots { [weak self] result in
            switch result {
            case .success(let spots):
                self?.spots = spots
                DispatchQueue.main.async {
                    self?.view?.reload()
                }
            case .failure(let error):
                log.warning(error.localizedDescription)
            }
        }
    }
}
