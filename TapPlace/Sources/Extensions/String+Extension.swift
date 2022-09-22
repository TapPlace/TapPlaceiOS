//
//  String+Extension.swift
//  TapPlace
//
//  Created by 박상현 on 2022/09/22.
//

import Foundation

extension String {
    var toBoolean: Bool {
        switch self {
        case "yes", "true", "y":
            return true
        default:
            return false
        }
    }
}
 
