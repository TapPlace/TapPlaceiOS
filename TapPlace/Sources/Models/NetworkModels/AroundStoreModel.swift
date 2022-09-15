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
struct AroundStores: Codable, Hashable {
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
    
    /**
     * @ StoreInfo -> AroundStores 변환
     * coder : sanghyeon
     */
    static func convertStoreInfo(storeInfo: StoreInfo) -> AroundStores {
        var returnPays: [String] = []
        if let storeFeedback = storeInfo.feedback {
            for feedback in storeFeedback {
                if feedback.exist {
                    returnPays.append(feedback.pay)
                }
            }
        }
        let returnAroundStores = AroundStores(num: 0, storeID: storeInfo.storeID, placeName: storeInfo.placeName, addressName: storeInfo.addressName, roadAddressName: storeInfo.roadAddressName, categoryGroupName: storeInfo.categoryGroupName, phone: storeInfo.phone, x: storeInfo.x, y: storeInfo.y, distance: 0, pays: returnPays)
        return returnAroundStores
    }
    /**
     * @ StoreInfo -> SearchMdel 변환
     * coder : sanghyeon
     */
    static func convertSearchModel(storeInfo: StoreInfo) -> SearchModel {
        let returnSearchModel = SearchModel(addressName: storeInfo.addressName, categoryGroupCode: "", categoryGroupName: storeInfo.categoryGroupName, distance: "", id: storeInfo.storeID, phone: storeInfo.phone, placeName: storeInfo.placeName, placeURL: "", roadAddressName: storeInfo.roadAddressName, x: storeInfo.x, y: storeInfo.y)
        
        return returnSearchModel
    }
}

//MARK: - 마커정보를 함께 저장할 구조체
struct AroundStoreMarkerModel {
    let store: AroundStores
    let marker: NMFMarker
}
