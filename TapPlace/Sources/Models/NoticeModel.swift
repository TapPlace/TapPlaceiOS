//
//  NoticeModel.swift
//  TapPlace
//
//  Created by 이상준 on 2022/09/05.
//

import Foundation

struct NoticeList: Decodable {
    let totalCount: String?
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

