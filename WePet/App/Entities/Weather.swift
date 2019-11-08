//
//  Weather.swift
//  WePet
//
//  Created by hb1love on 2019/10/15.
//  Copyright © 2019 depromeet. All rights reserved.
//

import UIKit

struct Weather: Codable {
    var type: WeatherType?
    var temperature: String?

    init() {}

    enum CodingKeys: String, CodingKey {
        case type = "weatherCode"
        case temperature = "temperature"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        if let temperatureCode = try values.decodeIfPresent(String.self, forKey: .type) {
            type = WeatherType(rawValue: temperatureCode.lowercased()) ?? .clear
        }
        temperature = try values.decodeIfPresent(String.self, forKey: .temperature)
    }

    var recommendCategory: CategoryType {
        guard let temperature = Double(self.temperature ?? "") else { return .cafe }
        switch (type, temperature) {
        case (.thunderstorm, _): return .mall
        case (.drizzle, _): return .mall
        case (.rain, _): return .mall
        case (.snow, 1...Double(Int.max)): return .cafe
        case (.snow, _): return .mall
        case (.mist, _): return .cafe
        case (.smoke, _): return .cafe
        case (.clear, 30...Double(Int.max)): return .restaurant
        case (.clear, _): return .park
        case (.clouds, 15...Double(Int.max)): return .park
        case (.clouds, _): return .cafe
        default:
            return .cafe
        }
    }
}

enum WeatherType: String, Codable {
    case thunderstorm
    case drizzle
    case rain
    case snow
    case mist
    case smoke
    case clear
    case clouds

    var displayName: String {
        switch self {
        case .thunderstorm: return "뇌우"
        case .drizzle: return "이슬비"
        case .rain: return "비"
        case .snow: return "눈"
        case .mist: return "흐림"
        case .smoke: return "안개"
        case .clear: return "맑음"
        case .clouds: return "구름약간"
        }
    }

    var icon: UIImage? {
        switch self {
        case .thunderstorm: return UIImage(named: "ic_rain")
        case .drizzle: return UIImage(named: "ic_rain")
        case .rain: return UIImage(named: "ic_rain")
        case .snow: return UIImage(named: "ic_snow")
        case .mist: return UIImage(named: "ic_mist")
        case .smoke: return UIImage(named: "ic_mist")
        case .clear: return UIImage(named: "ic_clear")
        case .clouds: return UIImage(named: "ic_clouds")
        }
    }
}
