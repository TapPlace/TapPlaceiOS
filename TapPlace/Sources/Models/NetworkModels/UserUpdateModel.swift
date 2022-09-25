//
//  UserUpdateModel.swift
//  TapPlace
//
//  Created by 박상현 on 2022/09/21.
//

import Foundation

// MARK: - UserUpdateModel
struct UserUpdateModel: Codable {
    let statusCode: Int
    let message: String?
    let error: String?
}
