//
//  FeedbackRequestModel.swift
//  TapPlace
//
//  Created by 박상현 on 2022/09/07.
//

import Foundation

struct FeedbackRequestModel {
    enum SelectPaymentFeedback {
        case success, fail
    }
    
    let feedback: LoadFeedbackList?
    let selected: SelectPaymentFeedback?
}

struct LoadFeedbackModel: Codable {
    let feedback: [LoadFeedbackList]
}

struct LoadFeedbackList: Codable {
    let exist: Bool
    let pay: String
}

struct FeedbackReamainModel: Codable {
    let remainCount: Int
    
    enum CodingKeys: String, CodingKey {
        case remainCount = "remain_count"
    }
}
