//
//  Location.swift
//  WePet
//
//  Created by hb1love on 2019/10/28.
//  Copyright © 2019 depromeet. All rights reserved.
//

struct Location: Codable {
    var latitude: Double?
    var longitude: Double?

    static let startupHub = Location(latitude: 37.394437, longitude: 127.1098543)
}
