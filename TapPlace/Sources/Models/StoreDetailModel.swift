//
//  StoreDetailModel.swift
//  TapPlace
//
//  Created by 이상준 on 2022/08/29.
//

import Foundation

enum StoreDetailModel {
    case storeInfo([StoreInfoModel])
    case storePayment([StorePaymentModel])
}

struct StoreInfoModel {
    let storeName: String?
    let storeKind: String?
    let address: String?
    let tel: String?
}

struct StorePaymentModel {
    let payName: String?
    let success: Bool?
    let successDate: String?
    let successRate: Int? // 성공률
}
