//
//  MapPresenter.swift
//  WePet
//
//  Created by hb1love on 2019/10/26.
//  Copyright © 2019 depromeet. All rights reserved.
//

import Foundation

protocol MapPresenterType {
    var spots: [Spot] { get }
    func viewDidLoad()
}

final class MapPresenter: MapPresenterType {
    private weak var view: MapViewControllerType?
    private var mapService: MapServiceType
    private var categories: [Category]

    private(set) var spots: [Spot] = []

    init(
        view: MapViewControllerType,
        mapService: MapServiceType,
        categories: [Category]
    ) {
        self.view = view
        self.mapService = mapService
        self.categories = categories
    }
}

extension MapPresenter {
    func viewDidLoad() {
//        mapService.getSpots { [weak self] result in
//            switch result {
//            case .success(let spots):
//                self?.spots = spots
//                DispatchQueue.main.async {
//                    self?.view?.reload()
//                }
//            case .failure(let error):
//                log.debug(error.localizedDescription)
//            }
//        }
    }
}
