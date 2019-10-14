//
//  WeatherAPI.swift
//  WePet
//
//  Created by hb1love on 2019/10/15.
//  Copyright © 2019 depromeet. All rights reserved.
//

import Foundation
import Moya

enum WeatherAPI {
    case weather
}

extension WeatherAPI: TargetType {
    var baseURL: URL {
        return URL(string: "http://localhost:8181")!
    }

    var path: String {
        switch self {
        case .weather:
            return "weather"
        }
    }

    var method: Moya.Method {
        switch self {
        default:
            return .get
        }
    }

    var task: Task {
        switch self {
        default:
            return .requestPlain
        }
    }

    var headers: [String: String]? {
        return ["Content-Type": "application/json"]
    }

    var sampleData: Data {
        switch self {
        case .weather:
            return "{\"type\": \"sunny\"}".data(using: String.Encoding.utf8)!
        }
    }
}
