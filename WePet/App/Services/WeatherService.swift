//
//  WeatherService.swift
//  WePet
//
//  Created by hb1love on 2019/10/15.
//  Copyright © 2019 depromeet. All rights reserved.
//

protocol WeatherServiceType {
    func weather(location: Location, _ completion: @escaping (Result<Weather, WepetError>) -> Void)
}

final class WeatherService: WeatherServiceType {
    private let networking: WeatherNetworking

    init(networking: WeatherNetworking) {
        self.networking = networking
    }

    func weather(location: Location, _ completion: @escaping (Result<Weather, WepetError>) -> Void) {
        guard let latitude = location.latitude,
            let longitude = location.longitude else { return }
        networking.request(.weather(latitude: latitude, longitude: longitude),
                           completion: completion)
    }
}
