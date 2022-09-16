//
//  NoticeModel.swift
//  TapPlace
//
//  Created by 이상준 on 2022/09/05.
//

import Foundation

struct NoticeModel: Decodable {
    let content: String?
    let time: String?
}

extension NoticeModel {
    static let lists: [NoticeModel] = [
        NoticeModel(content: "탑플레이스 새로운 공지사항 안내입니다.", time: "2022.00.00"),
        NoticeModel(content: "탑플레이스 새로운 공지사항 안내입니다.", time: "2022.00.00"),
        NoticeModel(content: "탑플레이스 새로운 공지사항 안내입니다.", time: "2022.00.00"),
        NoticeModel(content: "탑플레이스 새로운 공지사항 안내입니다.", time: "2022.00.00"),
        NoticeModel(content: "탑플레이스 새로운 공지사항 안내입니다.", time: "2022.00.00")
    ]
}

