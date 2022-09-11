//
//  UserSettingViewModel.swift
//  TapPlace
//
//  Created by 박상현 on 2022/08/29.
//

import Foundation

struct StorageViewModel: StorageProtocol {
    
    var userObject: UserModel?
    var dataBases: DB?
    
    init() {
        userObject = UserModel()
        dataBases = DB()
    }
    
    var numberOfFavoritePayments: Int {
        return dataBases?.realm.objects(UserFavoritePaymentsModel.self).count ?? 0
    }
    
    var numberOfBookmark: Int {
        return dataBases?.realm.objects(UserBookmarkStore.self).count ?? 0
    }
    
    var userFavoritePaymentsString: [String] {
        var returnPayments: [String] = []
        for payment in userFavoritePayments {
            returnPayments.append(PaymentModel.encodingPayment(payment: payment))
        }
        return returnPayments
    }
    
    var bookmarkDataSource: [UserBookmarkStore] {
        var returnBookmarks: [UserBookmarkStore] = []
        guard let userAllbookmark = dataBases?.realm.objects(UserBookmarkStore.self) else { return [] }
        userAllbookmark.forEach {
            returnBookmarks.append($0 as UserBookmarkStore)
        }
        return returnBookmarks
    }

    var userFavoritePayments: [PaymentModel] {
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
    
    
    mutating func loadFeedback() -> [UserFeedbackModel] {
        let objects = dataBases?.realm.objects(UserFeedbackModel.self).toArray(ofType: UserFeedbackModel.self) as [UserFeedbackModel]
        return objects
    }
}
