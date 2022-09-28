//
//  NoticeModel.swift
//  TapPlace
//
//  Created by 이상준 on 2022/09/05.
//

import Foundation

// 공지사항 모델
struct NoticeList: Decodable {
    let totalCount: String?
    let isEnd: Bool?
    let notice: NoticeDict?
    
    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case isEnd
        case notice
    }
}

struct NoticeDict: Decodable {
    let notice: [NoticeModel]
}

struct NoticeModel: Decodable {
    let title: String
    let content: String
    let writeDate: String
    
    enum CodingKeys: String, CodingKey {
        case title = "title"
        case content = "content"
        case writeDate = "write_date"
    }
}

