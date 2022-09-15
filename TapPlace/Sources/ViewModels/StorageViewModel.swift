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
    
    var numberOfFeedback: Int {
        return dataBases?.realm.objects(UserFeedbackStoreModel.self).count ?? 0
    }
    
    /// 1일 허용 피드백수 제한
    let numberOfAllowFeedback: Int = 3
    var numberOfTodayFeedback: Int {
        let today = "\(Date().getDate(3).split(separator: " ")[0])"
        return dataBases?.realm.objects(UserFeedbackStoreModel.self).filter {
            $0.date == today
        }.count ?? 0
    }
    var isAllowFeedback: Bool {
        if numberOfTodayFeedback >= numberOfAllowFeedback {
            return false
        } else {
            return true
        }
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
    
    var latestSearchStore: [LatestSearchStore] {
        var returnLatestSearchStore: [LatestSearchStore] = []
        guard let stores = dataBases?.realm.objects(LatestSearchStore.self) else { return returnLatestSearchStore }
        for store in stores {
            let tempStore = LatestSearchStore(storeID: store.storeID, placeName: store.placeName, locationX: store.locationX, locationY: store.locationY, addressName: store.addressName, roadAddressName: store.roadAddressName, storeCategory: store.storeCategory, date: store.date)
            returnLatestSearchStore.append(tempStore)
        }
        return returnLatestSearchStore
    }
    
    
    
    mutating func loadFeedbackStore() -> [UserFeedbackStoreModel] {
        let objects = dataBases?.realm.objects(UserFeedbackStoreModel.self).toArray(ofType: UserFeedbackStoreModel.self) as [UserFeedbackStoreModel]
        return objects
    }
    mutating func loadFeedback(store: UserFeedbackStoreModel) -> [UserFeedbackModel] {
        var tempFeedback: [UserFeedbackModel] = []
        let objects = dataBases?.realm.objects(UserFeedbackModel.self).filter {
            $0.date == store.date &&
            $0.storeID == store.storeID
        }
        objects?.forEach {
            tempFeedback.append($0)
        }
        return tempFeedback
    }
}
