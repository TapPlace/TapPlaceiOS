//
//  Storage.swift
//  TapPlace
//
//  Created by 박상현 on 2022/08/29.
//

import Foundation
import RealmSwift

struct DB {
    let realm = try! Realm()
    let location: URL = Realm.Configuration.defaultConfiguration.fileURL!
    var userObject: Results<UserModel>?
    var userFeedbackObject: Results<UserFeedbackModel>?
    var userPaymentsObject: Results<UserFeedbackModel>?
}

protocol UserProtocol {
    var userObject: UserModel? { get set }
    var dataBases: DB? { get set }
    
    mutating func existUser(uuid: String) -> Bool
    mutating func writeUser(_ user: UserModel)
    mutating func updateUser(_ user: UserModel)
    mutating func setPayments(_ payments: [String])
    mutating func getPayments() -> [PaymentModel]
}

extension UserProtocol {
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
}
