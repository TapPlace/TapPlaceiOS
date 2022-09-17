//
//  SearchModel.swift
//  TapPlace
//
//  Created by 이상준 on 2022/08/24.
//

import Foundation
import UIKit

struct RecentSearchModel {
    let image: UIImage?
    let placeName: String?
}

struct SearchList: Decodable {
    let documents: [SearchModel]
    let meta: MetaData
}

struct SearchModel: Decodable {
    let addressName, categoryGroupCode, categoryGroupName: String
    let distance, id, phone, placeName: String
    let placeURL: String
    let roadAddressName, x, y: String
    
    enum CodingKeys: String, CodingKey {
        case addressName = "address_name"
        case categoryGroupCode = "category_group_code"
        case categoryGroupName = "category_group_name"
        case distance, id, phone
        case placeName = "place_name"
        case placeURL = "place_url"
        case roadAddressName = "road_address_name"
        case x, y
    }
    
    /**
     * @ SearchModel -> StoreInfo 변환
     * coder : sanghyeon
     */
    static func convertStoreInfo(searchModel: SearchModel) -> StoreInfo {
        let tempStoreInfo = StoreInfo(num: 0, storeID: searchModel.id, placeName: searchModel.placeName, addressName: searchModel.addressName, roadAddressName: searchModel.roadAddressName, categoryGroupName: searchModel.categoryGroupName, phone: searchModel.phone, x: searchModel.x, y: searchModel.y, feedback: nil)
        return tempStoreInfo
    }
    /**
     * @ StoreInfo -> SearchModel 변환
     * coder : sanghyeon
     */
    static func convertSearchModel(storeInfo: StoreInfo) -> SearchModel {
        let tempSearchModel = SearchModel(addressName: storeInfo.addressName, categoryGroupCode: "", categoryGroupName: storeInfo.categoryGroupName, distance: "", id: storeInfo.storeID, phone: storeInfo.phone, placeName: storeInfo.placeName, placeURL: "", roadAddressName: storeInfo.roadAddressName, x: storeInfo.x, y: storeInfo.y)
        return tempSearchModel
                
    }
}

// MARK: - MetaData
struct MetaData: Codable {
    let isEnd: Bool
    let pageableCount: Int

    enum CodingKeys: String, CodingKey {
        case isEnd = "is_end"
        case pageableCount = "pageable_count"
    }
}
