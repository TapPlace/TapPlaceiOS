//
//  UserModel.swift
//  TapPlace
//
//  Created by 박상현 on 2022/08/29.
//

import UIKit
import RealmSwift
import CoreLocation

public var mainViewController: UIViewController?

/// 유저 정보
struct UserInfo {
    static var userLocation: CLLocationCoordinate2D?
    static var cameraLocation: CLLocationCoordinate2D?
}

/// 유저 계정 정보
class UserModel: Object {
    @Persisted(primaryKey: true) var uuid: String = Constants.keyChainDeviceID
    @Persisted var isFirstLaunch: Bool = false
    @Persisted var isAlarm: Bool = false
    @Persisted var fcmToken: String = ""

    
    convenience init(uuid: String, isFirstLaunch: Bool, isAlarm: Bool = false, fcmToken: String = "") {
        self.init()
        self.uuid = uuid
        self.isFirstLaunch = isFirstLaunch
        self.isAlarm = isAlarm
        self.fcmToken = fcmToken
    }
}

/// 관심결제수단
class UserFavoritePaymentsModel: Object {
    @Persisted var payments: String = ""
    @Persisted var brand: String = ""
    
    convenience init(payments: String, brand: String) {
        self.init()
        self.payments = payments
        self.brand = brand
    }
}

/// 최근 검색 가맹점
class LatestSearchStore: Object {
    @Persisted var storeID: String = ""
    @Persisted var placeName: String = ""
    @Persisted var locationX: Double = 0.0
    @Persisted var locationY: Double = 0.0
    @Persisted var addressName: String = ""
    @Persisted var roadAddressName: String = ""
    @Persisted var storeCategory: String = ""
    @Persisted var phone: String = ""
    @Persisted var date: String = ""
    
    convenience init(storeID: String, placeName: String, locationX: Double, locationY: Double, addressName: String, roadAddressName: String, storeCategory: String, phone: String, date: String) {
        self.init()
        self.storeID = storeID
        self.placeName = placeName
        self.locationX = locationX
        self.locationY = locationY
        self.addressName = addressName
        self.roadAddressName = roadAddressName
        self.storeCategory = storeCategory
        self.phone = phone
        self.date = date
    }
    
}

extension LatestSearchStore {
    func convertStoreInfo() -> StoreInfo {
        let tempStoreInfo = StoreInfo(num: 0, storeID: self.storeID, placeName: self.placeName, addressName: self.addressName, roadAddressName: self.roadAddressName, categoryGroupName: self.storeCategory, phone: "", x: "\(self.locationX)", y: "\(self.locationY)")
        return tempStoreInfo
    }
}
