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

    func viewDidLoad()
}

final class HomePresenter: HomePresenterType {
    private weak var view: HomeViewControllerType?
    private var mapService: MapServiceType
    private var weatherService: WeatherServiceType

    private(set) var spots: [Spot] = []
    private(set) var selectedCategory: Category = .favorite

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
    func viewDidLoad() {
        fetchSpots()
        view?.updateSelectedCategory(.cafe)
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
                log.debug(error.localizedDescription)
            }
        }
    }
}
