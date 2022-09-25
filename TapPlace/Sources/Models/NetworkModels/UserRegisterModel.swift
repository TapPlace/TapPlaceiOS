//
//  UserRegisterModel.swift
//  TapPlace
//
//  Created by 박상현 on 2022/09/22.
//

import Foundation

// MARK: - UserRegisterModel
struct UserRegisterModel: Codable {
    var userID, os, birth: String
    var pays: [String]
    var sex, personalDate, serviceDate: String
    var marketingAgree: Bool
    var key: String

    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case os, birth, pays, sex
        case personalDate = "personal_date"
        case serviceDate = "service_date"
        case marketingAgree = "marketing_agree"
        case key
    }
}

extension UserRegisterModel {
    static var setUser: UserRegisterModel = UserRegisterModel(userID: "", os: "", birth: "", pays: [], sex: "", personalDate: "", serviceDate: "", marketingAgree: false, key: "")
}
