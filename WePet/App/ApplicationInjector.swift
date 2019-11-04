//
//  ApplicationInjector.swift
//  WePet
//
//  Created by hb1love on 2019/10/15.
//  Copyright © 2019 depromeet. All rights reserved.
//

import UIKit
import SwiftyBeaver
import GoogleMaps

struct AppDependency {
    let window: UIWindow
    let coordinator: ApplicationCoordinator
    let configureSDKs: () -> Void
    let configureAppearance: () -> Void
}

struct ApplicationInjector {
    static func resolve() -> AppDependency {
        let window = UIWindow(frame: UIScreen.main.bounds)
        let rootController = UINavigationController()
        window.rootViewController = rootController
        window.backgroundColor = .white
        window.makeKeyAndVisible()

        let coordinator = ApplicationCoordinator(
            window: window,
            navigationController: rootController
        )
        return AppDependency(
            window: window,
            coordinator: coordinator,
            configureSDKs: configureSDKs,
            configureAppearance: configureAppearance
        )
    }

    static func configureSDKs() {
        configureLogger()
        configureMaps()
    }

    static func configureLogger() {
        let console = ConsoleDestination()
        log.addDestination(console)
    }
    
    static func configureMaps() {
        GMSServices.provideAPIKey("AIzaSyDpdG8O6veYWC-nh8lGWbAQaDpV7h8zMiM")
    }
    
    static func configureAppearance() {
        UINavigationBar.appearance().shadowImage = UIImage()
    }
}
