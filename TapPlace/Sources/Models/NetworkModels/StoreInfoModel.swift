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
}
