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
        EasyPaymentModel(designation: "", krDesignation: "기타 간편결제"),
        EasyPaymentModel(designation: "apple", krDesignation: "애플페이"),
        EasyPaymentModel(designation: "google", krDesignation: "구글페이"),
        EasyPaymentModel(designation: "conless", krDesignation: "컨택리스 카드")
    ]
}

struct PaymentModel {
    let payments: String
    let brand: String
    let designation: String
    var checked: Bool = false
}

extension PaymentModel {
    static var list: [PaymentModel] = [
        PaymentModel(payments: "", brand: "kakaopay", designation: "카카오페이"),
        PaymentModel(payments: "", brand: "naverpay", designation: "네이버페이"),
        PaymentModel(payments: "", brand: "zeropay", designation: "제로페이"),
        PaymentModel(payments: "", brand: "payco", designation: "페이코"),
        PaymentModel(payments: "apple", brand: "visa", designation: "애플페이 VISA"),
        PaymentModel(payments: "apple", brand: "master", designation: "애플페이 MASTER"),
        PaymentModel(payments: "apple", brand: "jcb", designation: "애플페이 JCB"),
        PaymentModel(payments: "google", brand: "visa", designation: "구글페이 VISA"),
        PaymentModel(payments: "google", brand: "master", designation: "구글페이 MASTER"),
        PaymentModel(payments: "google", brand: "maestro", designation: "구글페이 MAESTRO"),
        PaymentModel(payments: "conless", brand: "visa", designation: "컨택리스 VISA"),
        PaymentModel(payments: "conless", brand: "master", designation: "컨택리스 MASTER"),
        PaymentModel(payments: "conless", brand: "union", designation: "컨택리스 Union Pay"),
        PaymentModel(payments: "conless", brand: "amex", designation: "컨택리스 AMEX"),
        PaymentModel(payments: "conless", brand: "jcb", designation: "컨택리스 JCB")
    ]
    
    static var favoriteList: [PaymentModel] = []
    
    static func thisPayment(payment: String) -> PaymentModel? {
        /// 기타 간편결제 구분
        if payment.contains("_") == false {
            guard let index = self.list.firstIndex(where: { $0.brand == payment }) else { return nil }
            let resultPayment = self.list[index]
            return resultPayment
        }
        // 기타 제외 간편결제 구분
        let paymentArr = payment.split(separator: "_")
        guard let index = self.list.firstIndex(where: { $0.payments == paymentArr[0] && $0.brand == paymentArr[1] }) else { return nil }
        let resultPayment = self.list[index]
        return resultPayment
    }
    
    static func encodingPayment(payment: PaymentModel) -> String {
        /// 기타 간편결제
        if payment.payments == "" {
            return payment.brand
        }
        /// 기타 제외 간편결제
        let mixPayment = payment.payments + "_" + payment.brand
        return mixPayment
    }
}



enum Payments: String {
    case applepay = "애플페이"
    case googlepay = "구글페이"
    case contactless = "컨택리스 카드"
    case etc = "etc"
}
