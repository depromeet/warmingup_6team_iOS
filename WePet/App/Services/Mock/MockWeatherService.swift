//
//  MockWeatherService.swift
//  WePet
//
//  Created by hb1love on 2019/11/05.
//  Copyright © 2019 depromeet. All rights reserved.
//

final class MockWeatherService: WeatherServiceType {
    private let networking: WeatherNetworking

    init(networking: WeatherNetworking) {
        self.networking = networking
    }

    func weather(location: Location, _ completion: @escaping (Result<Weather, WepetError>) -> Void) {
        var weather = Weather()
        weather.type = .thunderstorm
        weather.temperature = "21"
        completion(.success(weather))
    }
}
