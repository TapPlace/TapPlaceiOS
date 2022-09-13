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
}

extension RecentSearchModel {
    static let list: [RecentSearchModel] = [
        RecentSearchModel(image: UIImage(systemName: "fork.knife.circle.fill"), placeName: "세븐 일레븐 등촌 3호점"),
        RecentSearchModel(image: UIImage(systemName: "fork.knife.circle.fill"), placeName: "BBQ 등촌행복점"),
        RecentSearchModel(image: UIImage(systemName: "fork.knife.circle.fill"), placeName: "세븐 일레븐 등촌 3호점"),
        RecentSearchModel(image: UIImage(systemName: "fork.knife.circle.fill"), placeName:  "BBQ 등촌행복점")
    ]
}
