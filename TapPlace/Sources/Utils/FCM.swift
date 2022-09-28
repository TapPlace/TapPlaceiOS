//
//  FCM.swift
//  TapPlace
//
//  Created by 박상현 on 2022/09/21.
//

import Foundation
import Firebase
import FirebaseCore

struct FCM {
    static let shared = FCM()
    
    /**
     * @ FCM 토큰 생성
     * coder : sanghyeon
     */
    func generateFCMToken(completion: @escaping (String?) -> ()) {
        Messaging.messaging().token { token, error in
            if let error = error {
                completion(nil)
            } else if let token = token as? String {
                completion(token)
            }
        }
    }
}
