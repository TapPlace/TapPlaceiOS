//
//  UserAllCountModel.swift
//  TapPlace
//
//  Created by 박상현 on 2022/09/25.
//

import Foundation

struct UserAllCountModel: Codable {
    var bookmarkCount: String
    var feedbackCount: String
    var remainCount: Int
    
    enum CodingKeys: String, CodingKey {
        case bookmarkCount = "bookmark_count"
        case feedbackCount = "feedback_count"
        case remainCount = "remain_count"
    }
}
