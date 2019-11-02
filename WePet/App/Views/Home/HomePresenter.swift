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
    var selectedCategory: Category? { get }

    func didVisit(_ location: Location)
    func didSelectCategory(_ category: Category)
}

final class HomePresenter: HomePresenterType {
    private weak var view: HomeViewControllerType?
    private var mapService: MapServiceType
    private var weatherService: WeatherServiceType

    private(set) var weather: Weather?
    private(set) var categories: [Category] = []
    private(set) var selectedCategory: Category?
    private(set) var spots: [Spot] = []
    private var isLoaded = false
    private var currentLocation: Location?

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
        self.currentLocation = location
        fetchInitialData(location)
    }

    func didSelectCategory(_ category: Category) {
        self.selectedCategory = category
        fetchSpots()
    }
}

private extension HomePresenter {
    func fetchInitialData(_ location: Location) {
        let dispatchGroup = DispatchGroup()
        fetchWeather(location, dispatchGroup: dispatchGroup)
        fetchCategories(dispatchGroup: dispatchGroup)
        configureView(dispatchGroup: dispatchGroup)
    }

    func configureView(dispatchGroup: DispatchGroup? = nil) {
        dispatchGroup?.notify(queue: .main) {
            guard let category = self.getRecommendCategory() else { return }
            self.selectedCategory = category
            self.view?.configureCategory(category)
            self.fetchSpots()
        }
    }

    func getRecommendCategory() -> Category? {
        return categories.first(where: { $0.type == weather?.type?.recommendCategory })
            ?? categories.first
    }
}

private extension HomePresenter {
    func fetchWeather(_ location: Location, dispatchGroup: DispatchGroup? = nil) {
        dispatchGroup?.enter()
        weatherService.weather(location: location) { [weak self] result in
            switch result {
            case .success(let weather):
                self?.weather = weather
                DispatchQueue.main.async {
                    self?.view?.configureWeather(weather)
                    dispatchGroup?.leave()
                }
            case .failure(let error):
                log.warning(error)
                DispatchQueue.main.async {
                    dispatchGroup?.leave()
                }
            }
        }
    }

    func fetchCategories(dispatchGroup: DispatchGroup? = nil) {
        dispatchGroup?.enter()
        mapService.getCategories { [weak self] result in
            switch result {
            case .success(let categories):
                self?.categories = categories
                DispatchQueue.main.async {
                    self?.view?.setupCategories(categories)
                    dispatchGroup?.leave()
                }
            case .failure(let error):
                log.warning(error.localizedDescription)
            }
        }
    }

    func fetchSpots() {
        guard let location = currentLocation else { return }
        let spotParam = (distance: 1000, size: 3, categoryId: selectedCategory?.id)
        mapService.getSpots(location: location, spotParam: spotParam) { [weak self] result in
            switch result {
            case .success(let spots):
                self?.spots = Array(spots.prefix(3))
                DispatchQueue.main.async {
                    self?.view?.reloadTable()
                }
            case .failure(let error):
                log.warning(error.localizedDescription)
            }
        }
    }
}
