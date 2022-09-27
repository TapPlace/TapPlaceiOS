//
//  UserInfoResponseModel.swift
//  TapPlace
//
//  Created by 박상현 on 2022/09/27.
//

import Foundation

struct UserInfoResponseModel: Codable {
    let userID, birth, sex, token: String
    let marketingAgree: Bool

    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case birth, sex, token
        case marketingAgree = "marketing_agree"
    }
}
