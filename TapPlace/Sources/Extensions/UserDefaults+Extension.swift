//
//  UserDefaults+Extension.swift
//  TapPlace
//
//  Created by 박상현 on 2022/08/07.
//

import Foundation

extension UserDefaults {
    /**
     * @ 값이 있는지 없는지 확인
     * return : Bool
     * coder : sanghyeon
     */
    static func contains(_ key: String) -> Bool {
        return UserDefaults.standard.object(forKey: key) != nil
    }
}
