//
//  AroundModel.swift
//  TapPlace
//
//  Created by 박상현 on 2022/08/22.
//

import Foundation

//MARK: - 매장 필터 모델
struct StoreFilterModel {
    static var list: [StoreModel]?
}



//MARK: - 반경 모델
struct DistancelModel {
    let title: String
    let distance: Int
}

extension DistancelModel {
    static var selectedDistance = 1000
    static let lists = [
        DistancelModel(title: "500m", distance: 500),
        DistancelModel(title: "1km", distance: 1000),
        DistancelModel(title: "2km", distance: 2000),
        DistancelModel(title: "4km", distance: 4000),
        DistancelModel(title: "6km", distance: 6000)
    ]
    
    static func getDistance(distance: Int) -> String {
        if distance >= 1000 {
            let resultDistance = distance / 1000
            return "\(resultDistance)km"
        } else {
            return "\(distance)m"
        }
    }
}
