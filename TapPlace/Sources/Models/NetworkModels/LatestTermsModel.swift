//
//  LatestTermsModel.swift
//  TapPlace
//
//  Created by 박상현 on 2022/09/08.
//

import Foundation

struct LatestTermsModel: Codable {
    let personalDate, serviceDate: String

    enum CodingKeys: String, CodingKey {
        case personalDate = "personal_date"
        case serviceDate = "service_date"
    }
}

extension LatestTermsModel {
    static var latestServiceDate: String = ""
    static var latestPersonalDate: String = ""
}
