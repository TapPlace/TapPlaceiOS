//
//  LatestTermsModel.swift
//  TapPlace
//
//  Created by 박상현 on 2022/09/08.
//

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let latestTermsModel = try? newJSONDecoder().decode(LatestTermsModel.self, from: jsonData)

import Foundation

// MARK: - LatestTermsModelElement
struct LatestTermsModel: Codable {
    let personalDate, serviceDate: PersonalDateUnion

    enum CodingKeys: String, CodingKey {
        case personalDate = "personal_date"
        case serviceDate = "service_date"
    }
}

enum PersonalDateUnion: Codable {
    case bool(Bool)
    case string(String)

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode(Bool.self) {
            self = .bool(x)
            return
        }
        if let x = try? container.decode(String.self) {
            self = .string(x)
            return
        }
        throw DecodingError.typeMismatch(PersonalDateUnion.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for PersonalDateUnion"))
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .bool(let x):
            try container.encode(x)
        case .string(let x):
            try container.encode(x)
        }
    }
}

extension PersonalDateUnion {
    var stringValue: String? {
        switch self {
        case .bool(let value):
            return String(value)
        case .string(let value):
            return value
        }
    }
}


extension LatestTermsModel {
    static var latestServiceDate: String = ""
    static var latestPersonalDate: String = ""
}
