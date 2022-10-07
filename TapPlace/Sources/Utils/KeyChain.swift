//
//  KeyChain.swift
//  TapPlace
//
//  Created by 박상현 on 2022/09/16.
//

import Foundation
import SwiftKeychainWrapper

struct KeyChain {
    static func saveUserDeviceUUID(_ uuid: String) {
        KeychainWrapper.standard.set(uuid, forKey: "uuid")
    }
    
    static func readUserDeviceUUID() -> String? {
        guard let userUUID = KeychainWrapper.standard.string(forKey: "uuid") else { return nil }
        return userUUID
    }
    
    static func deleteUserDeviceUUID() {
        KeychainWrapper.standard.removeObject(forKey: "uuid")
        print("키체인 지웠어요")
        let temp = KeychainWrapper.standard.string(forKey: "uuid") ?? "없어요"
        print("지우고 다시 불러왔어요" + temp)
    }
}
