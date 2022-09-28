//
//  AddBookmarkResponseModel.swift
//  TapPlace
//
//  Created by 박상현 on 2022/09/22.
//

import Foundation

// MARK: - AddBookmarkResponseModel
struct AddBookmarkResponseModel: Codable {
    let statusCode: Int
    let message: String
}

enum AddBookmarkresultType {
    case success
    case already
    case overCount
}
