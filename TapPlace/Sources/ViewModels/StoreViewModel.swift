//
//  StoreViewModel.swift
//  TapPlace
//
//  Created by 박상현 on 2022/09/08.
//

import Foundation
import Alamofire
import CoreLocation

class StoreViewModel {
    let storeDataService = StoreDataService.shared
    
    /**
     * @ 주변 스토어 검색
     * coder : sanghyeon
     */
    func requestAroundStore(location: CLLocationCoordinate2D, pays: [String], completion: @escaping (AroundStoreModel?) -> ()) {
        let parameter: Parameters = [
            "x1": "\(location.longitude)",
            "y1": "\(location.latitude)",
            "pays": pays,
            "distance": 1.0
        ]
        print("요청받은 parameter", parameter)
        
        storeDataService.requestFetchAroundStore(parameter: parameter) { result, error in
            completion(result)
        }
        

    }
}
