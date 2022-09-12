//
//  Storage.swift
//  TapPlace
//
//  Created by 박상현 on 2022/08/29.
//

import Foundation
import RealmSwift

struct DB {
    let realm = try! Realm(configuration: Realm.Configuration(schemaVersion: 2))
    
//    static let configuration = Realm.Configuration(schemaVersion: 2)
//    let realm = try! Realm(configuration: DB.configuration)
    let location: URL = Realm.Configuration.defaultConfiguration.fileURL!
    var userObject: Results<UserModel>?
    var userFeedbackObject: Results<UserFeedbackModel>?
    var userPaymentsObject: Results<UserFeedbackModel>?
}

protocol StorageProtocol {
    var userObject: UserModel? { get set }
    var dataBases: DB? { get set }
}

extension StorageProtocol {
    mutating func existUser(uuid: String) -> Bool {
        let users = dataBases?.realm.objects(UserModel.self).where {
            $0.uuid == uuid
        }.first
        if users == nil {
            return false
        } else {
            return true
        }
    }
    mutating func getUserInfo(uuid: String) -> UserModel? {
        let users = dataBases?.realm.objects(UserModel.self).where {
            $0.uuid == uuid
        }.first
        return users
    }
    mutating func writeUser(_ user: UserModel) {
        try! dataBases?.realm.write {
            dataBases?.realm.add(user)
        }
    }
    /**
     * @ 유저 정보 (모델 단위) 수정
     * coder : sanghyeon
     */
    mutating func updateUser(_ user: UserModel) {
        try! dataBases?.realm.write {
            dataBases?.realm.add(user, update: .modified)
        }
    }
    
    /**
     * @ 결제수단 로컬 DB 저장
     * coder : sanghyeon
     */
    mutating func setPayments(_ payments: [String]) {
        try! dataBases?.realm.write {
            if let removeClass = dataBases?.realm.objects(UserFavoritePaymentsModel.self) {
                dataBases?.realm.delete(removeClass)
            }
            for payment in payments {
                guard let addPayment = PaymentModel.thisPayment(payment: payment) else { return }
                let addPaymentObject = UserFavoritePaymentsModel(payments: addPayment.payments, brand: addPayment.brand)
                dataBases?.realm.add(addPaymentObject)
            }
        }
    }
    
    /**
     * @ 즐겨찾기 저장
     * coder : sanghyeon
     */
    mutating func toggleBookmark(_ storeID: String) -> Bool {
        let targetStore = dataBases?.realm.objects(UserBookmarkStore.self).where {
            $0.storeID == storeID
        }.first
        if targetStore == nil {
            let bookmarkStore = UserBookmarkStore(storeID: storeID, date: CommonUtils.getDate(Date(), type: 3))
            try! dataBases?.realm.write {
                dataBases?.realm.add(bookmarkStore)
            }
            return true
        } else {
            if let targetStore = targetStore {
                try! dataBases?.realm.write {
                    dataBases?.realm.delete(targetStore)
                }
            }
            return false
        }
    }
    
    /**
     * @ 즐겨찾기 여부 확인
     * coder : sanghyeon
     */
    mutating func isStoreBookmark(_ storeID: String) -> Bool {
        let targetStore = dataBases?.realm.objects(UserBookmarkStore.self).where {
            $0.storeID == storeID
        }.first
        if targetStore == nil {
            return false
        } else {
            return true
        }
    }
}

extension Results {
    func toArray<T>(ofType: T.Type) -> [T] {
        var array = [T]()
        for i in 0 ..< count {
            if let result = self[i] as? T {
                array.append(result)
            }
        }

        return array
    }
}
