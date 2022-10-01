//
//  AppDelegate.swift
//  TapPlace
//
//  Created by 박상현 on 2022/08/03.
//

import UIKit
import NMapsMap
import IQKeyboardManagerSwift
import Firebase
import FirebaseCore
import UserNotifications

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    let fcmClass = FCM.shared
    var storageViewModel = StorageViewModel()
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        if let cliendId = Constants.naverClientId {
            NMFAuthManager.shared().clientId = cliendId
            //print("Naver Client ID:", cliendId)
        }
        
        //MARK: FCM Settings
        FirebaseApp.configure()
        UNUserNotificationCenter.current().delegate = self
        Messaging.messaging().delegate = self
        
        
//        if #available(iOS 10.0, *) {
//          // For iOS 10 display notification (sent via APNS)
//          UNUserNotificationCenter.current().delegate = self
//
//          let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
//            UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { granted, error in
//                if let _ = error {
//                    
//                } else {
//                    if granted {
//                        self.fcmClass.generateFCMToken() { result in
//                            if let result = result {
//                                self.storageViewModel.toggleAlarm(fcmToken: result)
//                            }
//                        }
//                    }
//                }
//            }
//        } else {
//          let settings: UIUserNotificationSettings =
//            UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
//          application.registerUserNotificationSettings(settings)
//        }

        
        application.registerForRemoteNotifications()
        
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = false
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        
        if #available(iOS 15.0, *) {
            UITableView.appearance().sectionHeaderTopPadding = .zero
        }
        
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

//MARK: Messaging Delegate for FCM
extension AppDelegate: UNUserNotificationCenterDelegate, MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        /// print("*** AppDelegate_ Get FCM TOKEN: \(fcmToken)")
    }
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification) async -> UNNotificationPresentationOptions {
        var alertType: UNNotificationPresentationOptions = []
        if #available(iOS 14, *) {
            alertType = [.banner, .list, .sound]
        } else {
            alertType = [.alert, .sound]
        }
        var storageViewModel = StorageViewModel()
        let userGetAlarm =  storageViewModel.getAlarm()
        if !userGetAlarm {
            return []
        }

        return [alertType]
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse) async {
        let userInfo = response.notification.request.content.userInfo
        if let pushType = userInfo["type"] as? String {
            fcmClass.pushType = pushType
        }
    }
}
