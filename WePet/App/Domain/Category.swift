//
//  Category.swift
//  WePet
//
//  Created by hb1love on 2019/10/26.
//  Copyright © 2019 depromeet. All rights reserved.
//

import UIKit

struct Category: Codable {
    var id: Int?
    var displayName: String?
    var searchKeyword: String?

    var type: CategoryType?

    enum CodingKeys: String, CodingKey {
        case id = "categoryId"
        case displayName
        case searchKeyword
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        displayName = try values.decodeIfPresent(String.self, forKey: .displayName)
        searchKeyword = try values.decodeIfPresent(String.self, forKey: .searchKeyword)
        if let keyword = searchKeyword, let categoryType = CategoryType(rawValue: keyword) {
            type = categoryType
        }
    }
}

enum CategoryType: String, CaseIterable {
    case favorite
    case park
    case hospital
    case mall
    case cafe
    case restaurant

    var introText: String {
        switch self {
        case .favorite: return ""
        case .park: return "날이 좋아요\n가까운 공원에서 산책 어떠세요?"
        case .hospital: return ""
        case .mall: return "날씨가 좋지 않아요\n집에서 새 장난감과 놀아볼까요?"
        case .cafe: return "조금 추운 날씨예요\n포근한 펫카페 어떠세요?"
        case .restaurant: return "날도 더운데\n보양식 한그릇 어떠세요?"
        }
    }

    var image: UIImage? {
        switch self {
        case .favorite: return nil
        case .park: return UIImage(named: "bg_park")
        case .hospital: return nil
        case .mall: return UIImage(named: "bg_mall")
        case .cafe: return UIImage(named: "bg_cafe")
        case .restaurant: return UIImage(named: "bg_restaurant")
        }
    }
}
