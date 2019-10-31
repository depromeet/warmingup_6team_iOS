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
    private var categories: [Category]

    private(set) var spots: [Spot] = []

    init(
        view: BottomSheetViewControllerType,
        mapService: MapServiceType,
        categories: [Category]
    ) {
        self.view = view
        self.mapService = mapService
        self.categories = categories
    }
}

extension BottomSheetPresenter {
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
