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
    case weather(latitude: Double, longitude: Double)
}

extension WeatherAPI: TargetType {
    var baseURL: URL {
        return URL(string: "http://ec2-54-180-149-69.ap-northeast-2.compute.amazonaws.com/api")!
    }

    var path: String {
        switch self {
        case .weather(let latitude, let longitude):
            return "weather/\(latitude)/\(longitude)"
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
        case .weather:
            return .requestPlain
        }
    }

    var headers: [String: String]? {
        return ["Content-Type": "application/json"]
    }

    var sampleData: Data {
        switch self {
        case .weather:
            return Data()
        }
    }
}
