//
//  NotificationCenter+Extension.swift
//  TapPlace
//
//  Created by 박상현 on 2022/09/21.
//

import Foundation

extension Notification.Name {
    /// 주변 필터 적용
    static let applyAroundFilter = Notification.Name(rawValue: "applyFilter")
    /// 공유하기
    static let showShare = Notification.Name(rawValue: "showShare")
}
