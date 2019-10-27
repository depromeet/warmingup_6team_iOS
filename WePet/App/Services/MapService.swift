//
//  MapService.swift
//  WePet
//
//  Created by hb1love on 2019/10/15.
//  Copyright © 2019 depromeet. All rights reserved.
//

protocol MapServiceType {
    func getSpots(_ completion: @escaping (Result<[Spot], WepetError>) -> Void)
}

final class MapService: MapServiceType {
    private let networking: MapNetworking

    init(networking: MapNetworking) {
        self.networking = networking
    }

    func getSpots(_ completion: @escaping (Result<[Spot], WepetError>) -> Void) {
//        networking.request(.spots, completion: completion)
        completion(.success([Spot(), Spot(), Spot()]))
    }
}
