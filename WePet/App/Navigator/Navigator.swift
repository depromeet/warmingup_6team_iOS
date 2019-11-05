//
//  Navigator.swift
//  WePet
//
//  Created by hb1love on 2019/11/05.
//  Copyright © 2019 depromeet. All rights reserved.
//

import UIKit

protocol Navigatable {
    var navigator: Navigator? { get set }
}

enum TransitionType {
    case root
    case push
    case present
}

enum ViewType {
    case home
    case map(categories: [Category], selectedCategory: Category)
    case spotDetail(spot: Spot, location: Location?)

    func instantiateViewController() -> UIViewController & Navigatable {
        switch self {
        case .home:
            return makeHomeViewController()
        case .map(let categories, let selectedCategory):
            return makeMapViewController(categories, selectedCategory)
        case .spotDetail(let spot, let location):
            return makeSpotDetailViewController(spot, location)
        }
    }
}

extension ViewType {
    private func makeHomeViewController() -> HomeViewController {
        let view = HomeViewController()
        let presenter = HomePresenter(
            view: view,
            mapService: type(of: self).mapService,
            weatherService: type(of: self).weatherService
        )
        view.presenter = presenter
        return view
    }

    private func makeMapViewController(_ categories: [Category], _ selectedCategory: Category) -> MapViewController {
        let view = MapViewController()
        let presenter = MapPresenter(
            view: view,
            mapService: type(of: self).mapService,
            categories: categories,
            selectedCategory: selectedCategory
        )
        view.presenter = presenter
        return view
    }

    private func makeSpotDetailViewController(_ spot: Spot, _ location: Location?) -> SpotDetailViewController {
        let view = SpotDetailViewController.controllerFromStoryboard("SpotDetail")
        let presenter = SpotDetailPresenter(
            view: view,
            mapService: type(of: self).mapService,
            spot: spot,
            location: location
        )
        view.presenter = presenter
        return view
    }
}

private extension ViewType {
    #if DEV
    static let weatherService = MockWeatherService(networking: WeatherNetworking())
    static let mapService = MockMapService(networking: MapNetworking())
    #else
    static let weatherService = WeatherService(networking: WeatherNetworking())
    static let mapService = MapService(networking: MapNetworking())
    #endif
}

class Navigator {
    var window: UIWindow
    var navigationController: UINavigationController
    weak var view: UIViewController?

    init(window: UIWindow, navigationController: UINavigationController) {
        self.window = window
        self.navigationController = navigationController
    }

    func show(_ viewType: ViewType, transition: TransitionType, animated: Bool = true) {
        var view = viewType.instantiateViewController()
        let navigator = Navigator(window: window, navigationController: navigationController)
        navigator.view = view
        view.navigator = navigator

        DispatchQueue.main.async {
            switch transition {
            case .root:
                self.navigationController.setViewControllers([view], animated: animated)
                self.window.rootViewController = self.navigationController
            case .push:
                guard let navigationController = self.view?.navigationController else {
                    fatalError("Can't push without a navigation controller")
                }
                navigationController.pushViewController(view, animated: animated)
            case .present:
                self.view?.present(view, animated: animated)
            }
        }
    }

    func pop(isModal: Bool = false, animated: Bool = true) {
        DispatchQueue.main.async {
            if let navigationController = self.view?.navigationController {
                if isModal {
                    navigationController.dismiss(animated: animated, completion: nil)
                } else if navigationController.popViewController(animated: animated) == nil {
                    if let presentingView = self.view?.presentingViewController {
                        return presentingView.dismiss(animated: animated)
                    } else {
                        fatalError("Can't navigate back")
                    }
                }
            } else if let presentingView = self.view?.presentingViewController {
                presentingView.dismiss(animated: animated)
            } else {
                fatalError("Neither modal nor navigation! Can't navigate back from \(String(describing: self.view))")
            }
        }
    }
}
