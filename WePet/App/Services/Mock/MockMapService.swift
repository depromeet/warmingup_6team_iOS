//
//  MockMapService.swift
//  WePet
//
//  Created by hb1love on 2019/11/05.
//  Copyright © 2019 depromeet. All rights reserved.
//

import UIKit

final class MockMapService: MapServiceType {
    private let networking: MapNetworking

    private(set) var deviceId: String? = UIDevice.current.identifierForVendor?.uuidString

    init(networking: MapNetworking) {
        self.networking = networking
    }

    func getCategories(_ completion: @escaping (Result<[Category], WepetError>) -> Void) {
        networking.request(.categories, completion: completion)
    }

    func getSpots(location: Location, spotParam: SpotParam, _ completion: @escaping (Result<[Spot], WepetError>) -> Void) {
        completion(.success(type(of: self).mockSpots()))
    }

    func getSpot(placeId: String?, location: Location?, _ completion: @escaping (Result<Spot, WepetError>) -> Void) {
        completion(.success(type(of: self).mockSpots().first!))
    }

    func setFavorite(placeId: String, favorite: Bool, _ completion: @escaping (Result<(), WepetError>) -> Void) {
        completion(.success(()))
    }

    static func mockSpots() -> [Spot] {
        let spot = Spot(
            name: "숲안어린이공원",
            photoUrl: "https://maps.googleapis.com/maps/api/place/photo?maxwidth=4128&photoreference=CmRaAAAAlfjMOVBS_XpJh0ptm2C4Oku7aePeTncon6DZi4pLdAKazYxHXlpJ8CnEo8Lx6NZVh8bfeLypa7vTEE2uQioVrO3bImGkRqLMPbz0YIpKsxpOaoTran737imU1iny0-P7EhDwoJUQu2Xspzrhi8mRMDq4GhTeSBjQ7FBhydH_U3VUz9cFOw68FQ&key=AIzaSyBOOga6nSWG1hgnoaSOKh9ZG2x37l5L5dk",
            placeId: "ChIJD3RwdwVYezUR7CA-80WfkOY",
            latitude: 37.3890312,
            longitude: 127.11585,
            distance: 801,
            address: "성남시 분당구 백현동",
            wishList: false,
            homePage: "http://naver.com",
            phoneNumber: "01-234-5678"
        )
        return [spot, spot, spot]
    }
}
