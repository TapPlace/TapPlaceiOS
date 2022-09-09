//
//  SearchAroundStore.swift
//  TapPlace
//
//  Created by 박상현 on 2022/09/08.
//

import Foundation
import NMapsMap

// MARK: - AroundStoreModel
struct AroundStoreModel: Codable {
    let stores: [AroundStores]
}

// MARK: - Store
struct AroundStores: Codable {
    let num: Int
    let storeID, placeName, addressName, roadAddressName: String
    let categoryGroupName, phone, x, y: String
    let distance: Double
    let pays: [String]

    enum CodingKeys: String, CodingKey {
        case num
        case storeID = "store_id"
        case placeName = "place_name"
        case addressName = "address_name"
        case roadAddressName = "road_address_name"
        case categoryGroupName = "category_group_name"
        case phone, x, y, distance, pays
    }
}

extension AroundStoreModel {
    static var list: [AroundStores]?
    
    static var numberOfAroundStores: Int {
        guard let aroundStoreList = AroundStoreModel.list else { return 0 }
        return aroundStoreList.count
    }
}

//MARK: - 마커정보를 함께 저장할 구조체
struct AroundStoreMarkerModel {
    let store: AroundStores
    let marker: NMFMarker
}
