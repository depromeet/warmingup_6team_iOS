//
//  WeatherService.swift
//  WePet
//
//  Created by hb1love on 2019/10/15.
//  Copyright © 2019 depromeet. All rights reserved.
//

protocol WeatherServiceType {
    func today(_ completion: @escaping (Result<Weather, WepetError>) -> Void)
}

final class WeatherService: WeatherServiceType {
    private let networking: WeatherNetworking

    init(networking: WeatherNetworking) {
        self.networking = networking
    }

    func today(_ completion: @escaping (Result<Weather, WepetError>) -> Void) {
        networking.request(.weather, completion: completion)
    }
}
