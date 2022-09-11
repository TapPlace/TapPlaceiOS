//
//  StoreModel.swift
//  TapPlace
//
//  Created by 박상현 on 2022/08/10.
//

import UIKit

//MARK: - 스토어 카테고리 모델
struct StoreModel {
    let id: String
    let title: String
    var color: UIColor = .black
}

extension StoreModel {
    static let lists = [
        StoreModel(id: "FD6", title: "음식점", color: .init(hex: 0xFF6635)),
        StoreModel(id: "CE7", title: "카페", color: .init(hex: 0xFF6635)),
        StoreModel(id: "CS2", title: "편의점", color: .init(hex: 0x15AEEF)),
        StoreModel(id: "MT1", title: "마트", color: .init(hex: 0x15AEEF)),
        StoreModel(id: "OL7", title: "주유소", color: .init(hex: 0x2C4BEE)),
        StoreModel(id: "PK6", title: "주차장"),
        StoreModel(id: "PO3", title: "공공기관"),
        StoreModel(id: "AD5", title: "숙박"),
        StoreModel(id: "HP8", title: "병원"),
        StoreModel(id: "PM9", title: "약국"),
        StoreModel(id: "", title: "기타")
    ]
}
