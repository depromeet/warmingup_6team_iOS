//
//  MapService.swift
//  WePet
//
//  Created by hb1love on 2019/10/15.
//  Copyright © 2019 depromeet. All rights reserved.
//

import UIKit

typealias SpotParam = (distance: Int, size: Int, categoryId: Int?)
typealias FavoriteParam = (id: Int?, placeId: String, deviceId: String)
protocol MapServiceType {
    func getCategories(_ completion: @escaping (Result<[Category], WepetError>) -> Void)
    func getSpots(location: Location, spotParam: SpotParam, _ completion: @escaping (Result<[Spot], WepetError>) -> Void)
    func getSpot(placeId: String?, location: Location?, _ completion: @escaping (Result<Spot, WepetError>) -> Void)
}

final class MapService: MapServiceType {
    private let networking: MapNetworking

    private(set) var deviceId: String? = UIDevice.current.identifierForVendor?.uuidString

    init(networking: MapNetworking) {
        self.networking = networking
    }

    func getCategories(_ completion: @escaping (Result<[Category], WepetError>) -> Void) {
        networking.request(.categories, completion: completion)
    }

    func getSpots(location: Location, spotParam: SpotParam, _ completion: @escaping (Result<[Spot], WepetError>) -> Void) {
        guard let latitude = location.latitude,
            let longitude = location.longitude,
            let deviceId = self.deviceId else {
                completion(.failure(.requestFailed))
                return
        }

        networking.request(
            .spots(
                latitude: latitude,
                longitude: longitude,
                spotParam: spotParam,
                deviceId: deviceId
            )
        ) { (result: (Result<Content<[Spot]>, WepetError>)) -> Void in
            switch result {
            case .success(let content):
                completion(.success((content.content ?? [])))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func getSpot(placeId: String?, location: Location?, _ completion: @escaping (Result<Spot, WepetError>) -> Void) {
        guard let latitude = location?.latitude,
            let longitude = location?.longitude,
            let placeId = placeId,
            let deviceId = self.deviceId else {
                completion(.failure(.requestFailed))
                return
        }

        networking.request(
            .spot(
                latitude: latitude,
                longitude: longitude,
                placeId: placeId,
                deviceId: deviceId
            ),
            completion: completion
        )
    }
}
