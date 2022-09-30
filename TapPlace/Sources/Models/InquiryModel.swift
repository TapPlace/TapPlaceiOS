//
//  InquiryModel.swift
//  TapPlace
//
//  Created by 이상준 on 2022/09/27
//

import Foundation

// MARK: - Welcome
struct InquiryList: Decodable {
    let totalCount: String?
    let isEnd: Bool?
    let qna: [InquiryModel]?

    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case isEnd
        case qna
    }
}

// MARK: - Qna
struct InquiryModel: Decodable {
    let num: Int
    let userID: String
    let category: String
    let title, content, writeDate: String
    let os: String
    let answerCheck: Int
    let storeId: String
    let answer: String

    enum CodingKeys: String, CodingKey {
        case num
        case userID = "user_id"
        case category
        case title
        case content
        case writeDate = "write_date"
        case os
        case answerCheck = "answer_check"
        case storeId = "store_id"
        case answer
    }
}
