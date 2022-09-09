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
        MarkerModel(groupName: "편의점", markerImage: "convenience")
    ]
}
