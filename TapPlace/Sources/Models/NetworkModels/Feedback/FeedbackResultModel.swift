//
//  FeedbackResultModel.swift
//  TapPlace
//
//  Created by 박상현 on 2022/09/13.
//

import Foundation

// MARK: - FeedbackResultModel
struct FeedbackResultModel: Codable {
    let feedbackResult: [FeedbackResult]
    let remainCount: Int

    enum CodingKeys: String, CodingKey {
        case feedbackResult = "feedback_result"
        case remainCount = "remain_count"
    }
}

// MARK: - FeedbackResult
struct FeedbackResult: Codable {
    let pay: String
    let success, fail: Int
    let lastState: String

    enum CodingKeys: String, CodingKey {
        case pay, success, fail
        case lastState = "last_state"
    }
}
