// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let storeInfo = try? newJSONDecoder().decode(StoreInfo.self, from: jsonData)

import Foundation
 
// MARK: - StoreInfo
struct StoreInfo: Codable {
    let num: Int
    let storeID, placeName, addressName, roadAddressName: String
    let categoryGroupName, phone, x, y: String
    let feedback: [Feedback]?

    enum CodingKeys: String, CodingKey {
        case num
        case storeID = "store_id"
        case placeName = "place_name"
        case addressName = "address_name"
        case roadAddressName = "road_address_name"
        case categoryGroupName = "category_group_name"
        case phone, x, y, feedback
    }
    
    static let emptyStoreInfo = StoreInfo(num: 0, storeID: "", placeName: "", addressName: "", roadAddressName: "", categoryGroupName: "", phone: "", x: "", y: "", feedback: nil)
    /**
     * @ AroundStores -> StoreInfo 변환
     * coder : sanghyeon
     */
    static func convertAroundStores(aroundStore: AroundStores) -> StoreInfo {
        var storeFeedback: [Feedback] = []
        for pay in aroundStore.pays {
            let feedback = Feedback(num: nil, storeID: nil, success: nil, fail: nil, lastState: nil, lastTime: nil, pay: pay, exist: true)
            storeFeedback.append(feedback)
        }
        let resultStoreInfo: StoreInfo = StoreInfo(num: aroundStore.num, storeID: aroundStore.storeID, placeName: aroundStore.placeName, addressName: aroundStore.addressName, roadAddressName: aroundStore.roadAddressName, categoryGroupName: aroundStore.categoryGroupName, phone: aroundStore.phone, x: aroundStore.x, y: aroundStore.y, feedback: storeFeedback)
        
        return resultStoreInfo
    }
}
  
// MARK: - Feedback
struct Feedback: Codable {
    let num: Int?
    let storeID: String?
    let success, fail: Int?
    let lastState, lastTime: String?
    let pay: String
    let exist: Bool

    enum CodingKeys: String, CodingKey {
        case num
        case storeID = "store_id"
        case success, fail
        case lastState = "last_state"
        case lastTime = "last_time"
        case pay, exist
    }
    
    static let emptyFeedback = Feedback(num: 0, storeID: "", success: 0, fail: 0, lastState: "", lastTime: "", pay: "", exist: true)
}
