//
//  Category.swift
//  WePet
//
//  Created by hb1love on 2019/10/26.
//  Copyright © 2019 depromeet. All rights reserved.
//

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
}
