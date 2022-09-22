//
//  Codable+Extension.swift
//  TapPlace
//
//  Created by 박상현 on 2022/09/22.
//

import Foundation

extension Encodable {
    var toDictionary : [String: Any]? {
        guard let object = try? JSONEncoder().encode(self) else { return nil }
        guard let dictionary = try? JSONSerialization.jsonObject(with: object, options: []) as? [String:Any] else { return nil }
        return dictionary
    }
}
