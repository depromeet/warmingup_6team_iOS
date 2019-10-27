//
//  Category.swift
//  WePet
//
//  Created by hb1love on 2019/10/26.
//  Copyright © 2019 depromeet. All rights reserved.
//

enum Category: String, CaseIterable {
    case favorite
    case park
    case hospital
    case mall
    case cafe
    case restaurant

    var title: String {
        switch self {
        case .favorite: return "즐겨찾기"
        case .park: return "공원"
        case .hospital: return "병원"
        case .mall: return "용품"
        case .cafe: return "카페"
        case .restaurant: return "식당"
        }
    }
}
