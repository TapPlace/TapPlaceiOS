//
//  UserModel.swift
//  TapPlace
//
//  Created by 박상현 on 2022/08/29.
//

import Foundation
import RealmSwift


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
class UserFeedbackModel: Object {
    @Persisted var storeID: String = ""
    @Persisted var feedback: Bool = false
    @Persisted var date: String = ""
    
    convenience init(storeID: String, feedback: Bool, date: String) {
        self.init()
        self.storeID = storeID
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
    @Persisted var date: Date = Date()
    
    convenience init(storeID: String, date: Date) {
        self.init()
        self.storeID = storeID
        self.date = date
    }
}
