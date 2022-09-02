//
//  AroundModel.swift
//  TapPlace
//
//  Created by 박상현 on 2022/08/22.
//

import Foundation

//MARK: - 매장 필터 모델
struct AroundFilterModel {
    static var storeList: [StoreModel] = []
    static var paymentList: [PaymentModel] = []
}



//MARK: - 반경 모델
struct DistancelModel {
    let title: String
    let distance: Double
}

extension DistancelModel {
    static var selectedDistance = 1.0
    static let lists = [
        DistancelModel(title: "500m", distance: 0.5),
        DistancelModel(title: "1km", distance: 1.0),
        DistancelModel(title: "2km", distance: 2.0),
        DistancelModel(title: "4km", distance: 4.0),
        DistancelModel(title: "6km", distance: 6.0)
    ]
    
    static func getDistance(distance: Double) -> String {
        if distance >= 1.0 {

            let processedDistance = String(format: "%.1f", distance)
            return "\(processedDistance)km"
        } else {

            let resultDistance = distance * 1000
            let processedDistance = round(resultDistance)
            let processedDistanceArr = String(processedDistance).split(separator: ".")
            return "\(processedDistanceArr[0])m"
        }
    }
}


