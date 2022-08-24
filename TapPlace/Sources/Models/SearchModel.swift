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
    let storeName: String?
}

struct SearchModel {
    let image: UIImage?
    let storeName: String?
    let distance: Int?
    let address: String?
}

extension RecentSearchModel {
    static var list: [RecentSearchModel] = [
        RecentSearchModel(image: UIImage(systemName: "fork.knife.circle.fill"), storeName: "세븐 일레븐 등촌 3호점"),
        RecentSearchModel(image: UIImage(systemName: "fork.knife.circle.fill"), storeName: "BBQ 등촌행복점"),
        RecentSearchModel(image: UIImage(systemName: "fork.knife.circle.fill"), storeName: "세븐 일레븐 등촌 3호점"),
        RecentSearchModel(image: UIImage(systemName: "fork.knife.circle.fill"), storeName:  "BBQ 등촌행복점")
    ]
}
