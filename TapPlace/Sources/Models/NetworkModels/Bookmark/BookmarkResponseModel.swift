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
    var bookmarks: [Bookmark]?

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
    var isChecked: Bool? = false

    enum CodingKeys: String, CodingKey {
        case num
        case storeID = "store_id"
        case placeName = "place_name"
        case addressName = "address_name"
        case roadAddressName = "road_address_name"
        case categoryGroupName = "category_group_name"
        case phone, x, y, isChecked
    }
}

//MARK: - Bookmark Extensions
extension Bookmark{
    /**
     * @ Bookmark -> SearchModel 변환
     * coder : sanghyeon
     */
    func convertSearchModel() -> SearchModel {
        let tempSearchModel = SearchModel(addressName: self.addressName, categoryGroupCode: "", categoryGroupName: self.categoryGroupName, distance: "", id: self.storeID, phone: self.phone, placeName: self.placeName, placeURL: "", roadAddressName: self.roadAddressName, x: self.x, y: self.y)
        return tempSearchModel
    }
    /**
     * @ Bookmark -> StoreInfo 변환
     * coder : sanghyeon
     */
    func convertStoreInfo() -> StoreInfo {
        let tempStoreInfo = StoreInfo(num: self.num, storeID: self.storeID, placeName: self.placeName, addressName: self.addressName, roadAddressName: self.roadAddressName, categoryGroupName: self.categoryGroupName, phone: self.phone, x: self.x, y: self.y)
        return tempStoreInfo
    }
}
