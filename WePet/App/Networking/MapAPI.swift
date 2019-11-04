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
    case spot(latitude: Double, longitude: Double, placeId: String, deviceId: String)
    case spots(latitude: Double, longitude: Double, spotParam: SpotParam, deviceId: String)
    case setFavorite(favoriteParam: FavoriteParam)
    case removeFavorite(deviceId: String, placeId: String)
}

extension MapAPI: TargetType {
    var baseURL: URL {
        return URL(string: "http://ec2-54-180-149-69.ap-northeast-2.compute.amazonaws.com/api")!
    }

    var path: String {
        switch self {
        case .categories:
            return "category"
        case .spot(let latitude, let longitude, let placeId, _):
            return "location/\(latitude)/\(longitude)/\(placeId)"
        case .spots(let latitude, let longitude, _, _):
            return "location/\(latitude)/\(longitude)"
        case .setFavorite:
            return "wishList"
        case .removeFavorite(let deviceId, let placeId):
            return "wishList/\(deviceId)/\(placeId)"
        }
    }

    var method: Moya.Method {
        switch self {
        case .setFavorite:
            return .post
        case .removeFavorite:
            return .delete
        default:
            return .get
        }
    }

    var task: Task {
        switch self {
        case .spot(_, _, _, let deviceId):
            return .requestParameters(
                parameters: ["deviceId": deviceId],
                encoding: URLEncoding.default
            )
        case .spots(_, _, let spotParam, let deviceId):
            return .requestParameters(
                parameters: makeSpotsParameters(spotParam: spotParam, deviceId: deviceId),
                encoding: URLEncoding.default
            )
        case .setFavorite(let favoriteParam):
            return .requestParameters(
                parameters: makeFavoriteParameters(favoriteParam: favoriteParam),
                encoding: JSONEncoding.default
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
    func makeSpotsParameters(spotParam: SpotParam, deviceId: String) -> [String: Any] {
        var parameters = [String: Any]()
        parameters["deviceId"] = deviceId
        parameters["distance"] = spotParam.distance
        parameters["size"] = spotParam.size
        parameters["page"] = 1
        if let categoryId = spotParam.categoryId {
            parameters["categoryId"] = categoryId
        }
        return parameters
    }

    func makeFavoriteParameters(favoriteParam: FavoriteParam) -> [String: Any] {
        var parameters = [String: Any]()
        parameters["placeId"] = favoriteParam.placeId
        parameters["deviceId"] = favoriteParam.deviceId
        return parameters
    }
}
