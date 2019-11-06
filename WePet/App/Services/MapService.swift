//
//  MapService.swift
//  WePet
//
//  Created by hb1love on 2019/10/15.
//  Copyright © 2019 depromeet. All rights reserved.
//

import UIKit

typealias SpotParam = (distance: Int, size: Int, categoryId: Int?)
typealias FavoriteParam = (placeId: String, deviceId: String)
protocol MapServiceType {
    func getCategories(_ completion: @escaping (Result<[Category], WepetError>) -> Void)
    func getSpots(location: Location, spotParam: SpotParam, _ completion: @escaping (Result<[Spot], WepetError>) -> Void)
    func getSpot(placeId: String?, location: Location?, _ completion: @escaping (Result<Spot, WepetError>) -> Void)
    func setFavorite(placeId: String, favorite: Bool, _ completion: @escaping (Result<(), WepetError>) -> Void)
}

final class MapService: MapServiceType {
    private let networking: MapNetworking

    private(set) var deviceId: String? = UIDevice.current.identifierForVendor?.uuidString
    private var recentLocation: Location?

    init(networking: MapNetworking) {
        self.networking = networking
    }

    func getCategories(_ completion: @escaping (Result<[Category], WepetError>) -> Void) {
        networking.request(.categories, completion: completion)
    }

    func getSpots(location: Location, spotParam: SpotParam, _ completion: @escaping (Result<[Spot], WepetError>) -> Void) {
        guard let latitude = location.latitude ?? recentLocation?.latitude,
            let longitude = location.longitude ?? recentLocation?.longitude,
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
        ) { [weak self] (result: (Result<Content<[Spot]>, WepetError>)) -> Void in
            switch result {
            case .success(let content):
                self?.recentLocation = Location(latitude: latitude, longitude: longitude)
                completion(.success((content.content ?? [])))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func getSpot(placeId: String?, location: Location?, _ completion: @escaping (Result<Spot, WepetError>) -> Void) {
        guard let latitude = location?.latitude ?? recentLocation?.latitude,
            let longitude = location?.longitude ?? recentLocation?.longitude,
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

    func setFavorite(placeId: String, favorite: Bool, _ completion: @escaping (Result<(), WepetError>) -> Void) {
        guard let deviceId = self.deviceId else {
            completion(.failure(.requestFailed))
            return
        }

        if favorite {
            postFavorite(favoriteParam: (placeId: placeId, deviceId: deviceId), completion)
        } else {
            deleteFavorite(placeId: placeId, deviceId: deviceId, completion)
        }
    }

    func postFavorite(favoriteParam: FavoriteParam, _ completion: @escaping (Result<(), WepetError>) -> Void) {
        networking.requestWithLog(.setFavorite(favoriteParam: favoriteParam)) { result in
            switch result {
            case .success:
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func deleteFavorite(placeId: String, deviceId: String, _ completion: @escaping (Result<(), WepetError>) -> Void) {
        networking.requestWithLog(.removeFavorite(deviceId: deviceId, placeId: placeId)) { result in
            switch result {
            case .success:
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
