//
//  KeyChain.swift
//  TapPlace
//
//  Created by 박상현 on 2022/09/16.
//

import Foundation

struct KeyChain {
    static func saveUserDeviceUUID(_ uuid: String) -> Bool {
        let query: [CFString: Any] = [kSecClass: kSecClassGenericPassword,
                                      kSecAttrService: "TapPlace",
                                      kSecAttrAccount: "User",
                                      kSecAttrGeneric: uuid]

        return SecItemAdd(query as CFDictionary, nil) == errSecSuccess
    }
    
    static func loadUserDeviceUUID() -> String? {
        let query: [CFString: Any] = [kSecClass: kSecClassGenericPassword,
                                kSecAttrService: "TapPlace",
                                kSecAttrAccount: "User",
                                 kSecMatchLimit: kSecMatchLimitOne,
                           kSecReturnAttributes: true,
                                 kSecReturnData: true]
        var item: CFTypeRef?
        
        if SecItemCopyMatching(query as CFDictionary, &item) != errSecSuccess {
            return nil
        }
        
        guard let existingItem = item as? [String: Any],
              let data = existingItem[kSecAttrGeneric as String] as? Data,
              let returnData = String(data: data, encoding: .utf8) else { return nil }
        
        return(returnData)
    }
}
