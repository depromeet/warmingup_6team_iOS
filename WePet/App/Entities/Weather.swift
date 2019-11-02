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

    var recommendCategory: CategoryType {
        switch self {
        case .thunderstorm: return .cafe
        case .drizzle: return .cafe
        case .rain: return .cafe
        case .snow: return .cafe
        case .mist: return .cafe
        case .smoke: return .cafe
        case .clear: return .park
        case .clouds: return .cafe
        }
    }

    var introText: String {
        switch self {
        case .thunderstorm: return "조금 추운 날씨예요\n포근한 펫카페 어떠세요?"
        case .drizzle: return "조금 추운 날씨예요\n포근한 펫카페 어떠세요?"
        case .rain: return "조금 추운 날씨예요\n포근한 펫카페 어떠세요?"
        case .snow: return "조금 추운 날씨예요\n포근한 펫카페 어떠세요?"
        case .mist: return "조금 추운 날씨예요\n포근한 펫카페 어떠세요?"
        case .smoke: return "조금 추운 날씨예요\n포근한 펫카페 어떠세요?"
        case .clear: return "화창한 날씨에\n산책을 나가보는게 어떨까요?"
        case .clouds: return "조금 추운 날씨예요\n포근한 펫카페 어떠세요?"
        }
    }

    var icon: UIImage? {
        switch self {
        case .thunderstorm: return UIImage(named: "ic_cloud")
        case .drizzle: return UIImage(named: "ic_cloud")
        case .rain: return UIImage(named: "ic_cloud")
        case .snow: return UIImage(named: "ic_cloud")
        case .mist: return UIImage(named: "ic_cloud")
        case .smoke: return UIImage(named: "ic_cloud")
        case .clear: return UIImage(named: "ic_cloud")
        case .clouds: return UIImage(named: "ic_cloud")
        }
    }
}
