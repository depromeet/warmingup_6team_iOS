//
//  ResponseData.swift
//  WePet
//
//  Created by hb1love on 2019/10/28.
//  Copyright © 2019 depromeet. All rights reserved.
//

import Foundation

class ResponseData<T: Codable>: Codable {
    var message: String?
    var data: T?
}

class Content<T: Codable>: Codable {
    var content: T?
}
