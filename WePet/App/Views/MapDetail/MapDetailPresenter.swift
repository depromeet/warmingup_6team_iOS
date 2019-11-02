//
//  MapDetailPresenter.swift
//  WePet
//
//  Created by 양혜리 on 01/11/2019.
//  Copyright © 2019 depromeet. All rights reserved.
//

import Foundation

protocol MapDetailPresenterType {
    var spot: Spot { get }
    func viewDidLoad()
}

final class MapDetailPresenter: MapDetailPresenterType {
    private weak var view: MapDetailViewControllerType?
    private var categories: [Category]

    private(set) var spot: Spot

    init(
        view: MapDetailViewControllerType,
        spot: Spot,
        categories: [Category]
    ) {
        self.view = view
        self.spot = spot
        self.categories = categories
    }
}

extension MapDetailPresenter {
    func viewDidLoad() {
    
    }
}

