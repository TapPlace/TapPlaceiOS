//
//  Authorization.swift
//  TapPlace
//
//  Created by 박상현 on 2022/09/20.
//

import Foundation
import CoreLocation
import UserNotifications

struct Authorization {
    //MARK: Single Tone Pattern
    static let shared = Authorization()
    
    //MARK: Location Authorization
    /**
     * @ 위치권한 상태 가져오기
     * coder : sanghyeon
     */
    func getLocationAuthorizationStatus() -> CLAuthorizationStatus {
        return CLLocationManager.authorizationStatus()
    }
    /**
     * @ 위치권한 요청
     * coder : sanghyeon
     */
    func requestLocationAuthorization() {
        let locationManager = CLLocationManager()
        locationManager.requestWhenInUseAuthorization()
    }
    
    //MARK: Notification Authorization
    /**
     * @ 알림권한 요청
     * coder : sanghyeon
     */
    func requestNotificationAuthorization(completion: @escaping (Bool)->()) {
        let authOptions = UNAuthorizationOptions(arrayLiteral: .alert, .badge, .sound)
       
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions, completionHandler: {didAllow,Error in
            if didAllow {
                completion(true)
            } else {
                completion(false)
            }
        })
    }
    
}
