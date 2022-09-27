//
//  FeedbackResponseModel.swift
//  TapPlace
//
//  Created by 박상현 on 2022/09/27.
//

import Foundation

// MARK: - FeedbackResponseModel
struct FeedbackResponseModel: Codable {
    let totalCount: String
    let isEnd: Bool
    var feedbacks: [FeedbackList]

    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case isEnd, feedbacks
    }
}

// MARK: - FeedbackResponseModelFeedback
struct FeedbackList: Codable {
    let num: Int
    let userID: String
    let feedback: [UserFeedbackResult]
    let storeID: String
    var date: String
    let placeName: String
    let addressName: String
    let roadAddressName: String
    let categoryGroupName: String
    let phone: String
    let x, y: String

    enum CodingKeys: String, CodingKey {
        case num
        case userID = "user_id"
        case feedback, date
        case storeID = "store_id"
        case placeName = "place_name"
        case addressName = "address_name"
        case roadAddressName = "road_address_name"
        case categoryGroupName = "category_group_name"
        case phone, x, y
    }
}

// MARK: - FeedbackFeedback
struct UserFeedbackResult: Codable {
    let pay: String
    let feed: Bool
}

extension FeedbackList {
    func convertStoreInfo() -> StoreInfo {
        let tempStoreInfo = StoreInfo(num: self.num , storeID: self.storeID, placeName: self.placeName, addressName: self.addressName, roadAddressName: self.roadAddressName, categoryGroupName: self.categoryGroupName, phone: self.phone, x: self.x, y: self.y)
        return tempStoreInfo
    }
}
