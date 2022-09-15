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
    @Persisted(primaryKey: true) var uuid: String = CommonUtils.getDeviceUUID()
    @Persisted var isFirstLaunch: Bool = false
    @Persisted var agreeTerm: String = ""
    @Persisted var agreePrivacy: String = ""
    @Persisted var agreeMarketing: String = ""
    @Persisted var birth: String = ""
    @Persisted var sex: String = ""
    
    convenience init(uuid: String, isFirstLaunch: Bool, agreeTerm: String, agreePrivacy: String, agreeMarketing: String, birth: String, sex: String) {
        self.init()
        self.uuid = uuid
        self.isFirstLaunch = isFirstLaunch
        self.agreeTerm = agreeTerm
        self.agreePrivacy = agreePrivacy
        self.agreeMarketing = agreeMarketing
        self.birth = birth
        self.sex = sex
    }
}

/// 유저 피드백
class UserFeedbackStoreModel: Object {
    @Persisted var storeID: String = ""
    @Persisted var storeName: String = ""
    @Persisted var storeCategory: String = ""
    @Persisted var locationX: Double = 0.0
    @Persisted var locationY: Double = 0.0
    @Persisted var address: String = ""
    @Persisted var date: String = ""
    
    convenience init(storeID: String, storeName: String, storeCategory: String, locationX: Double, locationY: Double, address: String, date: String) {
        self.init()
        self.storeID = storeID
        self.storeName = storeName
        self.storeCategory = storeCategory
        self.locationX = locationX
        self.locationY = locationY
        self.address = address
        self.date = date
    }
}
class UserFeedbackModel: Object {
    @Persisted var storeID: String = ""
    @Persisted var pay: String = ""
    @Persisted var feedback: Bool = false
    @Persisted var date: String = ""
    
    convenience init(storeID: String, pay: String, feedback: Bool, date: String) {
        self.init()
        self.storeID = storeID
        self.pay = pay
        self.feedback = feedback
        self.date = date
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

/// 즐겨찾는 매장
class UserBookmarkStore: Object {
    @Persisted var storeID: String = ""
    @Persisted var placeName: String = ""
    @Persisted var locationX: Double = 0.0
    @Persisted var locationY: Double = 0.0
    @Persisted var addressName: String = ""
    @Persisted var roadAddressName: String = ""
    @Persisted var storeCategory: String = ""
    @Persisted var date: String = ""
    
    convenience init(storeID: String, placeName: String, locationX: Double, locationY: Double, addressName: String, roadAddressName: String, storeCategory: String, date: String) {
        self.init()
        self.storeID = storeID
        self.placeName = placeName
        self.locationX = locationX
        self.locationY = locationY
        self.addressName = addressName
        self.roadAddressName = roadAddressName
        self.storeCategory = storeCategory
        self.date = date
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
