//
//  MapService.swift
//  WePet
//
//  Created by hb1love on 2019/10/15.
//  Copyright © 2019 depromeet. All rights reserved.
//

typealias SpotParam = (distance: Int, size: Int, categoryId: Int?)
protocol MapServiceType {
    func getCategories(_ completion: @escaping (Result<[Category], WepetError>) -> Void)
    func getSpots(location: Location, spotParam: SpotParam, _ completion: @escaping (Result<[Spot], WepetError>) -> Void)
}

final class MapService: MapServiceType {
    private let networking: MapNetworking

    init(networking: MapNetworking) {
        self.networking = networking
    }

    func getCategories(_ completion: @escaping (Result<[Category], WepetError>) -> Void) {
        networking.request(.categories, completion: completion)
    }

    func getSpots(location: Location, spotParam: SpotParam, _ completion: @escaping (Result<[Spot], WepetError>) -> Void) {
        guard let latitude = location.latitude,
            let longitude = location.longitude else { return }
        networking.request(.spots(latitude: latitude, longitude: longitude, spotParam: spotParam), completion: completion)
    }
}
