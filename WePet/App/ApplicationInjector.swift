//
//  ApplicationInjector.swift
//  WePet
//
//  Created by NHNEnt on 2019/10/15.
//  Copyright © 2019 depromeet. All rights reserved.
//

import UIKit
import SwiftyBeaver

struct AppDependency {
    let configureSDKs: () -> Void
    let configureAppearance: () -> Void
}

struct ApplicationInjector {
    static func resolve() -> AppDependency {
        return AppDependency(
            configureSDKs: configureSDKs,
            configureAppearance: configureAppearance
        )
    }

    static func configureSDKs() {
        configureLogger()
    }

    static func configureLogger() {
        let console = ConsoleDestination()
        log.addDestination(console)
    }

    static func configureAppearance() {
        UINavigationBar.appearance().shadowImage = UIImage()
    }
}
