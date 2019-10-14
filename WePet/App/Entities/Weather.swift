//
//  Weather.swift
//  WePet
//
//  Created by hb1love on 2019/10/15.
//  Copyright © 2019 depromeet. All rights reserved.
//

struct Weather: Codable {
    var type: WeatherType?
}

enum WeatherType: String, Codable {
    case sunny
}
