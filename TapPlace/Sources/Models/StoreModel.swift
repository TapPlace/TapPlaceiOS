//
//  StoreModel.swift
//  TapPlace
//
//  Created by 박상현 on 2022/08/10.
//

import Foundation

struct StoreModel {
    let id: String
    let title: String
    let image: String
}

extension StoreModel {
    static let storeList = [
        StoreModel(id: "a", title: "카페/디저트", image: ""),
        StoreModel(id: "b", title: "식당", image: ""),
        StoreModel(id: "c", title: "도서", image: ""),
        StoreModel(id: "d", title: "편의점/마트", image: ""),
        StoreModel(id: "e", title: "패션/쇼핑", image: ""),
        StoreModel(id: "f", title: "뷰티/미용", image: ""),
        StoreModel(id: "a", title: "카페/디저트", image: ""),
        StoreModel(id: "b", title: "식당", image: ""),
        StoreModel(id: "c", title: "도서", image: ""),
        StoreModel(id: "d", title: "편의점/마트", image: ""),
        StoreModel(id: "e", title: "패션/쇼핑", image: ""),
        StoreModel(id: "f", title: "뷰티/미용", image: "")
    ]
}
