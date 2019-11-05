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
    private let navigator: Navigator

    init(
        window: UIWindow,
        navigationController: UINavigationController
    ) {
        self.window = window
        self.navigationController = navigationController
        self.navigator = Navigator(
            window: window,
            navigationController: navigationController
        )
    }

    func start() {
        navigator.show(.home, transition: .root)
    }
}
