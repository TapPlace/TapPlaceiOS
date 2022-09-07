//
//  AlarmModel.swift
//  TapPlace
//
//  Created by 이상준 on 2022/09/06.
//

import Foundation

struct AlarmModel {
    let subTitle: String?
    let title: String?
    let time: String?
}

extension AlarmModel {
    static let lists: [AlarmModel] = [
        AlarmModel(subTitle: "알림 소제목", title: "탑플레이스 알림 제목 영역입니다. 알림내용은 두줄정도로 정해보았습니다. 의견주세요 :)", time: "2022.00.00"),
        AlarmModel(subTitle: "알림 소제목", title: "탑플레이스 알림 제목 영역입니다. 알림내용은 두줄정도로 정해보았습니다. 의견주세요 :)", time: "2022.00.00"),
        AlarmModel(subTitle: "알림 소제목", title: "탑플레이스 알림 제목 영역입니다. 알림내용은 두줄정도로 정해보았습니다. 의견주세요 :)", time: "2022.00.00"),
        AlarmModel(subTitle: "알림 소제목", title: "탑플레이스 알림 제목 영역입니다. 알림내용은 두줄정도로 정해보았습니다. 의견주세요 :)", time: "2022.00.00"),
        AlarmModel(subTitle: "알림 소제목", title: "탑플레이스 알림 제목 영역입니다. 알림내용은 두줄정도로 정해보았습니다. 의견주세요 :)", time: "2022.00.00")
    ]
}
