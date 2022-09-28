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
 
    var userFavoritePaymentsString: [String] {
        var returnPayments: [String] = []
        for payment in userFavoritePayments {
            returnPayments.append(PaymentModel.encodingPayment(payment: payment))
        }
        return returnPayments
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
            let tempStore = LatestSearchStore(storeID: store.storeID, placeName: store.placeName, locationX: store.locationX, locationY: store.locationY, addressName: store.addressName, roadAddressName: store.roadAddressName, storeCategory: store.storeCategory, phone: store.phone, date: store.date)
            returnLatestSearchStore.append(tempStore)
        }
        return returnLatestSearchStore
    }
}
