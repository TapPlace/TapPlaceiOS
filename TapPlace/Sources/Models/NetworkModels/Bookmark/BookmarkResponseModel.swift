//
//  BookmarkResponseModel.swift
//  TapPlace
//
//  Created by 박상현 on 2022/09/22.
//

import Foundation

// MARK: - BookmarkResponseModel
struct BookmarkResponseModel: Codable {
    let totalCount: String
    let isEnd: Bool
    let bookmarks: [Bookmark]?

    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case isEnd, bookmarks
    }
}

// MARK: - Bookmark
struct Bookmark: Codable {
    let num: Int
    let storeID, placeName, addressName, roadAddressName: String
    let categoryGroupName, phone, x, y: String

    enum CodingKeys: String, CodingKey {
        case num
        case storeID = "store_id"
        case placeName = "place_name"
        case addressName = "address_name"
        case roadAddressName = "road_address_name"
        case categoryGroupName = "category_group_name"
        case phone, x, y
    }
}

