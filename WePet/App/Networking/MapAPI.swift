//
//  MapAPI.swift
//  WePet
//
//  Created by hb1love on 2019/10/15.
//  Copyright © 2019 depromeet. All rights reserved.
//

import Foundation
import Moya

enum MapAPI {
    case spots
    case favorite
}

extension MapAPI: TargetType {
    var baseURL: URL {
        return URL(string: "http://localhost:8181")!
    }

    var path: String {
        switch self {
        case .spots:
            return "spots"
        case .favorite:
            return "spots/favorite"
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
        case .spots:
            return "{[\"latitude\": 123123123.123, \"altitude\": 234234.234]}".data(using: String.Encoding.utf8)!
        default:
            return Data()
        }
    }
}
