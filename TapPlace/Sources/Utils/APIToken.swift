//
//  APIToken.swift
//  TapPlace
//
//  Created by 박상현 on 2022/09/20.
//

import Foundation
import SwiftJWT

struct APIToken {
    let secretKey = Constants.tapplaceSecretKey
    
    func generateToken() -> String? {
        let jwtHeader = Header()
        let payload = APIPayload(exp: Date(timeIntervalSinceNow: 5))
        var jwtToken = JWT(header: jwtHeader, claims: payload)
        
        guard let secretKeyData = secretKey.data(using: .utf8) else { return nil }
        
        do {
            let token = try jwtToken.sign(using: .hs384(key: secretKeyData))
            return token
        } catch {
            return nil
        }
        
    }
}

struct APIPayload: Claims, Codable {
    let role: String = "user"
    let exp: Date
}
