//
//  InquiryModel.swift
//  TapPlace
//
//  Created by 이상준 on 2022/09/27
//

import Foundation

// MARK: - Welcome
struct InquiryList: Decodable {
    let totalCount: String
    let isEnd: Bool
    let inquiries: [InquiryModel]

    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case isEnd, inquiries
    }
}

// MARK: - Qna
struct InquiryModel: Decodable {
    let num: Int
    let userID: String
    let category: String
    let title, content, writeDate: String
    let email: String
    let os: String
    let answerCheck: Int

    enum CodingKeys: String, CodingKey {
        case num
        case userID = "user_id"
        case category, title, content
        case writeDate = "write_date"
        case email, os
        case answerCheck = "answer_check"
    }
}
