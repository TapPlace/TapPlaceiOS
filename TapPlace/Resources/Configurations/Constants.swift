//
//  Constants.swift
//  TapPlace
//
//  Created by 박상현 on 2022/08/14.
//

import Foundation

struct Constants {
    static let userDeviceID = CommonUtils.getDeviceUUID()
    static let naverClientId = Bundle.main.infoDictionary?["NAVER_CLIENT_ID"] as? String
    static let tapplaceBaseUrl = "https://tapplace.co.kr"
    static let latestTerm = "2022-09-01"
    static let latestPrivacy = "2022-09-01"
}
