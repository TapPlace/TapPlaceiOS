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

extension StorePaymentModel {
    static let lists: [StorePaymentModel] = [
        StorePaymentModel(payName: "카카오 페이", success: true, successDate: "2022.08.20", successRate: 95),
        StorePaymentModel(payName: "애플페이 - VISA", success: false, successDate: "2022.08.19", successRate: 80),
        StorePaymentModel(payName: "네이버 페이", success: true, successDate: "2022.08.21", successRate: 97),
        StorePaymentModel(payName: "네이버 페이", success: true, successDate: "2022.08.21", successRate: 97),
        StorePaymentModel(payName: "네이버 페이", success: true, successDate: "2022.08.21", successRate: 97),
        StorePaymentModel(payName: "네이버 페이", success: true, successDate: "2022.08.21", successRate: 97),
        StorePaymentModel(payName: "네이버 페이", success: true, successDate: "2022.08.21", successRate: 97),
        StorePaymentModel(payName: "네이버 페이", success: true, successDate: "2022.08.21", successRate: 97),
        StorePaymentModel(payName: "네이버 페이", success: true, successDate: "2022.08.21", successRate: 97)
    ]
}
