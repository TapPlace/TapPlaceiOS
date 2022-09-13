//
//  MarkerModel.swift
//  TapPlace
//
//  Created by 박상현 on 2022/09/09.
//

import Foundation

struct MarkerModel {
    let groupName: String
    let markerImage: String
}

extension MarkerModel {
    static let list = [
        MarkerModel(groupName: "편의점", markerImage: "store_pin"),
        MarkerModel(groupName: "마트", markerImage: "shop_pin"),
        MarkerModel(groupName: "음식점", markerImage: "restaurant_pin"),
        MarkerModel(groupName: "카페", markerImage: "cafe_fin"),
        MarkerModel(groupName: "주유소", markerImage: "gas_pin"),
        MarkerModel(groupName: "주차장", markerImage: "parking_pin"),
        MarkerModel(groupName: "병원", markerImage: "hospital_pin"),
        MarkerModel(groupName: "약국", markerImage: "drugstore_pin"),
        MarkerModel(groupName: "숙박", markerImage: "accommodation_pin"),
        MarkerModel(groupName: "공공기관", markerImage: "institutions_pin"),
        MarkerModel(groupName: "", markerImage: "etc_pin")
    ]
}
