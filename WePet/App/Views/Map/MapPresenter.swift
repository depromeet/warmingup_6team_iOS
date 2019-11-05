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
    var categories: [Category] { get }
    var selectedCategory: Category { get }
    func viewDidLoad()
    func didVisit(_ location: Location)
    func didSelectCategory(_ category: Category)
}

final class MapPresenter: MapPresenterType {
    private weak var view: MapViewControllerType?
    private var mapService: MapServiceType
    private(set) var categories: [Category]
    private(set) var selectedCategory: Category
    private(set) var spots: [Spot] = []
    private(set) var currentLocation: Location?
    private var isLoaded = false

    init(
        view: MapViewControllerType,
        mapService: MapServiceType,
        categories: [Category],
        selectedCategory: Category
        //ToDo: 저 위의 카테고리는 네비게이션 카테고리 의미, 선택된 카테고리를 따로 받는 부분 추가 예정
    ) {
        self.view = view
        self.mapService = mapService
        self.categories = categories
        self.selectedCategory = selectedCategory
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
    
    func didVisit(_ location: Location) {
        if isLoaded { return }
        isLoaded = true
        self.currentLocation = location
        fetchSpots()
    }
    
    func didSelectCategory(_ category: Category) {
        selectedCategory = category
        fetchSpots()
     }
}

private extension MapPresenter {
    func fetchSpots() {
        guard let location = currentLocation else { return }
        let spotParam = (distance: 3000, size: 20, categoryId: selectedCategory.id)
        mapService.getSpots(location: location, spotParam: spotParam) { [weak self] result in
            switch result {
            case .success(let spots):
                self?.spots = spots
                DispatchQueue.main.async {
                    self?.view?.reload()
                }
            case .failure(let error):
                log.warning(error.localizedDescription)
            }
        }
    }
}
