//
//  SearchModel.swift
//  TapPlace
//
//  Created by 이상준 on 2022/08/24.
//

import Foundation
import UIKit

struct RecentSearchModel {
    let image: UIImage?
    let placeName: String?
}

struct SearchModel: Decodable{
    let placeName: String?
    let distance: String?
    let address: String?
}

extension RecentSearchModel {
    static let list: [RecentSearchModel] = [
        RecentSearchModel(image: UIImage(systemName: "fork.knife.circle.fill"), placeName: "세븐 일레븐 등촌 3호점"),
        RecentSearchModel(image: UIImage(systemName: "fork.knife.circle.fill"), placeName: "BBQ 등촌행복점"),
        RecentSearchModel(image: UIImage(systemName: "fork.knife.circle.fill"), placeName: "세븐 일레븐 등촌 3호점"),
        RecentSearchModel(image: UIImage(systemName: "fork.knife.circle.fill"), placeName:  "BBQ 등촌행복점")
    ]
}
