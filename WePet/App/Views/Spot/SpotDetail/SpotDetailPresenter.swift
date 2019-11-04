//
//  SpotDetailPresenter.swift
//  WePet
//
//  Created by NHNEnt on 2019/11/02.
//  Copyright © 2019 depromeet. All rights reserved.
//

import Foundation

protocol SpotDetailPresenterType {
    var spot: Spot { get }
    func viewDidLoad()
}

final class SpotDetailPresenter: SpotDetailPresenterType {
    private weak var view: SpotDetailViewControllerType?
    private var mapService: MapServiceType

    private(set) var spot: Spot
    private(set) var currentLocation: Location?

    init(
        view: SpotDetailViewControllerType,
        mapService: MapServiceType,
        spot: Spot,
        location: Location?
    ) {
        self.view = view
        self.mapService = mapService
        self.spot = spot
        self.currentLocation = location
    }
}

extension SpotDetailPresenter {
    func viewDidLoad() {
        view?.configureSpot(spot)
        mapService.getSpot(placeId: spot.placeId, location: currentLocation) { [weak self] result in
            switch result {
            case .success(let spot):
                self?.spot = spot
                DispatchQueue.main.async {
                    self?.view?.configureSpot(spot)
                }
            case .failure(let error):
                log.warning(error)
            }
        }
    }
}

