//
//  PaymentModel.swift
//  TapPlace
//
//  Created by 박상현 on 2022/08/09.
//

import Foundation
import Realm

struct EasyPaymentModel {
    let designation: String
    let krDesignation: String
}

extension EasyPaymentModel {
    static var list: [EasyPaymentModel] = [
        EasyPaymentModel(designation: "etc", krDesignation: "기타 간편결제"),
        EasyPaymentModel(designation: "applepay", krDesignation: "애플페이"),
        EasyPaymentModel(designation: "googlepay", krDesignation: "구글페이"),
        EasyPaymentModel(designation: "contactless", krDesignation: "컨택리스 카드")
    ]
}

struct PaymentModel {
    let payments: String
    let brand: String
    let designation: String
}

extension PaymentModel {
    static var list: [PaymentModel] = [
        PaymentModel(payments: "etc", brand: "kakaopay", designation: "카카오페이"),
        PaymentModel(payments: "etc", brand: "naverpay", designation: "네이버페이"),
        PaymentModel(payments: "etc", brand: "zeropay", designation: "제로페이"),
        PaymentModel(payments: "etc", brand: "payco", designation: "페이코"),
        PaymentModel(payments: "applepay", brand: "visa", designation: "애플페이 비자"),
        PaymentModel(payments: "applepay", brand: "mastercard", designation: "애플페이 마스터카드"),
        PaymentModel(payments: "applepay", brand: "jcb", designation: "애플페이 JCB"),
        PaymentModel(payments: "googlepay", brand: "visa", designation: "구글페이 비자"),
        PaymentModel(payments: "googlepay", brand: "mastercard", designation: "구글페이 마스터카드"),
        PaymentModel(payments: "googlepay", brand: "maestro", designation: "구글페이 마에스트로"),
        PaymentModel(payments: "contactless", brand: "visa", designation: "컨택리스 비자"),
        PaymentModel(payments: "contactless", brand: "mastercard", designation: "컨택리스 마스터카드"),
        PaymentModel(payments: "contactless", brand: "unionpay", designation: "컨택리스 유니온페이"),
        PaymentModel(payments: "contactless", brand: "amex", designation: "컨택리스 아메리칸익스프레스"),
        PaymentModel(payments: "contactless", brand: "jcb", designation: "컨택리스 JCB")
    ]
    static var favoriteList: [PaymentModel]?
}



enum Payments: String {
    case applepay = "애플페이"
    case googlepay = "구글페이"
    case contactless = "컨택리스 카드"
    case etc = "etc"
}
