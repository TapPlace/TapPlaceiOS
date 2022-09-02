//
//  UserSettingViewModel.swift
//  TapPlace
//
//  Created by 박상현 on 2022/08/29.
//

import Foundation

struct UserSettingViewModel: UserProtocol {
    
    var userObject: UserModel?
    var dataBases: DB?
    
    init() {
        userObject = UserModel()
        dataBases = DB()
    }
    
    var numberOfFavoritePayments: Int {
        return dataBases?.realm.objects(UserFavoritePaymentsModel.self).count ?? 0
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
     * @ 유저 관심 결제수단 불러오기
     * coder : sanghyeon
     */
    mutating func getPayments() -> [PaymentModel] {
        var returnPayments: [PaymentModel] = []
        guard let payments = dataBases?.realm.objects(UserFavoritePaymentsModel.self) else { return returnPayments }
        for payment in payments {
            let paymentString = payment.payments == "" ? payment.brand : payment.payments + "_" + payment.brand
            let krDesignation = PaymentModel.thisPayment(payment: paymentString)
            let setPayment = PaymentModel(payments: payment.payments, brand: payment.brand, designation: krDesignation?.designation ?? "")
            returnPayments.append(setPayment)
        }
        return returnPayments
    }
}
