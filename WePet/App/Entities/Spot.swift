//
//  Spot.swift
//  WePet
//
//  Created by hb1love on 2019/10/15.
//  Copyright © 2019 depromeet. All rights reserved.
//

struct Spot: Codable {
    var name: String?
    var photoUrl: String?
    var placeId: String? // google placeId
    var latitude: Double?
    var longitude: Double?

    // detail api
    var homePage: String?
    var address: String?
    var phoneNumber: String?
}
