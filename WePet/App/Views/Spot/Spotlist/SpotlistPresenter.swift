//
//  SpotlistPresenter.swift
//  WePet
//
//  Created by hb1love on 2019/10/26.
//  Copyright © 2019 depromeet. All rights reserved.
//

import Foundation

protocol SpotlistPresenterType {
    var spots: [Spot] { get }

    func viewDidLoad()
}

final class SpotlistPresenter: SpotlistPresenterType {
    private weak var view: SpotlistViewControllerType?
    private var mapService: MapServiceType
    private var categories: [Category]

    private(set) var spots: [Spot] = []

    init(
        view: SpotlistViewControllerType,
        mapService: MapServiceType,
        categories: [Category]
    ) {
        self.view = view
        self.mapService = mapService
        self.categories = categories
    }
}

extension SpotlistPresenter {
    func viewDidLoad() {
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
