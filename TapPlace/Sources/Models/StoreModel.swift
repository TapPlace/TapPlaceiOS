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
    static let lists = [
        StoreModel(id: "MT1", title: "대형마트", image: ""),
        StoreModel(id: "CS2", title: "식당", image: ""),
        StoreModel(id: "PK6", title: "주차장", image: ""),
        StoreModel(id: "OL7", title: "주유소/충전소", image: "car.fill"),
        StoreModel(id: "PO3", title: "공공기관", image: ""),
        StoreModel(id: "AD5", title: "숙박", image: ""),
        StoreModel(id: "FD6", title: "음식점", image: ""),
        StoreModel(id: "CE7", title: "카페", image: ""),
        StoreModel(id: "HP8", title: "병원", image: ""),
        StoreModel(id: "PM9", title: "약국", image: ""),
        StoreModel(id: "", title: "기타", image: "")
    ]
}
