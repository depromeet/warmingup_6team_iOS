//
//  ApplicationCoordinator.swift
//  WePet
//
//  Created by hb1love on 2019/10/26.
//  Copyright © 2019 depromeet. All rights reserved.
//

import UIKit

final class ApplicationCoordinator {
    private let window: UIWindow
    private let navigationController: UINavigationController

    init(
        window: UIWindow,
        navigationController: UINavigationController
    ) {
        self.window = window
        self.navigationController = navigationController
    }

    func start() {
        let mapService = MapService(networking: MapNetworking())
        let weatherService = WeatherService(networking: WeatherNetworking())
        let view = HomeViewController()
        let presenter = HomePresenter(
            view: view,
            mapService: mapService,
            weatherService: weatherService
        )
        view.presenter = presenter
        navigationController.setViewControllers([view], animated: true)
        window.rootViewController = navigationController
    }
}
