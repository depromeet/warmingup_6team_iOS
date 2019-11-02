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
    case categories
    case spot(placeId: String)
    case spots(latitude: Double, longitude: Double, spotParam: SpotParam)
    case favorite
}

extension MapAPI: TargetType {
    var baseURL: URL {
        return URL(string: "http://ec2-54-180-149-69.ap-northeast-2.compute.amazonaws.com:8080/api")!
    }

    var path: String {
        switch self {
        case .categories:
            return "category"
        case .spot(let placeId):
            return "location/\(placeId)"
        case .spots(let latitude, let longitude, _):
            return "location/\(latitude)/\(longitude)"
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
        case .spots(_, _, let spotParam):
            return .requestParameters(
                parameters: makeSpotsParameters(spotParam: spotParam),
                encoding: URLEncoding.default
            )
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

private extension MapAPI {
    func makeSpotsParameters(spotParam: SpotParam) -> [String: Any] {
        var parameters = [String: Any]()
        parameters["distance"] = spotParam.distance
        parameters["size"] = spotParam.size
        if let categoryId = spotParam.categoryId {
            parameters["categoryId"] = categoryId
        }
        return parameters
    }
}
