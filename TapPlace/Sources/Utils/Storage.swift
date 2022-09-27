//
//  Storage.swift
//  TapPlace
//
//  Created by 박상현 on 2022/08/29.
//

import Foundation
import RealmSwift

struct DB {
    let realm = try! Realm(configuration: Realm.Configuration(schemaVersion: 8))
    let location: URL = Realm.Configuration.defaultConfiguration.fileURL!
    var userObject: Results<UserModel>?
    var userPaymentsObject: Results<UserFavoritePaymentsModel>?
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
     * @ 유저 정보 초기화
     * coder : sanghyeon
     */
    mutating func deleteUser(completion: (Bool) -> ()) {
        if let user = dataBases?.realm.objects(UserModel.self) {
            try! dataBases?.realm.write {
                dataBases?.realm.delete(user)
                completion(true)
            }
        } else {
            completion(false)
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
     * @ 결제수단 모두 삭제
     * coder : sanghyeon
     */
    mutating func deleteAllPayments(completion: () -> ()) {
        guard let targetPayment = dataBases?.realm.objects(UserFavoritePaymentsModel.self) else { return }
        try! dataBases?.realm.write {
            dataBases?.realm.delete(targetPayment)
        }
    }
 
    /**
     * @ 최근검색어 등록
     * coder : sanghyeon
     */
    mutating func addLatestSearchStore(store: LatestSearchStore) {
        if let targetData = dataBases?.realm.objects(LatestSearchStore.self).where { $0.storeID == store.storeID }.first {
            try! dataBases?.realm.write {
                dataBases?.realm.delete(targetData)
            }
        }
        try! dataBases?.realm.write {
            dataBases?.realm.add(store)
        }
    }
    
    /**
     * @ 최근검색어 삭제
     * coder : sanghyeon
     */
    mutating func deleteLatestSearchStore(store: Any) {
        if let stores = store as? String {
            guard let targetData = dataBases?.realm.objects(LatestSearchStore.self).where { $0.storeID == stores }.first else { return }
            try! dataBases?.realm.write {
                dataBases?.realm.delete(targetData)
            }
            return
        }
        if let stores = store as? [String] {
            stores.forEach { id in
                if let targetData = dataBases?.realm.objects(LatestSearchStore.self).where { $0.storeID == id }.first {
                    try! dataBases?.realm.write {
                        dataBases?.realm.delete(targetData)
                    }
                }
            }
            return
        }
    }
    /**
     * @ 초기화용 전체기록 전체 삭제
     * coder : sanghyeon
     */
    func deleteAllSearchHistory() {
        let targetLatestSearchStore = dataBases?.realm.objects(LatestSearchStore.self)
        guard let targetLatestSearchStore = targetLatestSearchStore else { return  }
        try! dataBases?.realm.write {
            dataBases?.realm.delete(targetLatestSearchStore)
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
