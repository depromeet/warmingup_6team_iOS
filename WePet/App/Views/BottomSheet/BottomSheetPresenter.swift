//
//  BottomSheetPresenter.swift
//  WePet
//
//  Created by 양혜리 on 30/10/2019.
//  Copyright © 2019 depromeet. All rights reserved.
//

import Foundation

protocol BottomSheetPresenterType {
    var spots: [Spot] { get }
    func viewDidLoad()
}

final class BottomSheetPresenter: BottomSheetPresenterType {
    private weak var view: BottomSheetViewControllerType?
    private var mapService: MapServiceType
    private var categories: [Category]?

    private(set) var spots: [Spot] = []

    init(
        view: BottomSheetViewControllerType,
        mapService: MapServiceType,
        categories: [Category]?,
        spots: [Spot]
    ) {
        self.view = view
        self.mapService = mapService
        self.categories = categories
        self.spots = spots
    }
}

extension BottomSheetPresenter {
    func viewDidLoad() {
        
    }
}
