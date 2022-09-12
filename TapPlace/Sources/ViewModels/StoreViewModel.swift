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
        storeDataService.requestFetchAroundStore(parameter: parameter) { result, error in
            completion(result)
        }
    }
    /**
     * @ 스토어 아이디로 가맹점 정보 요청
     * coder : sanghyeon
     */
    func requestStoreInfo(storeID: String, pays: [String], completion: @escaping (StoreInfo?) -> ()) {
        let parameter: Parameters = [
            "store_id": storeID,
            "pays": pays
        ]
        storeDataService.requestFetchStoreInfo(parameter: parameter) { result, error in
            completion(result)
        }
    }
    /**
     * @ 카카오 로컬 API로 현재 주소 요청
     * coder : sanghyeon
     */
    func requestGeoAddress(location: CLLocationCoordinate2D, completion: @escaping (KakaoGeoAddresModel) -> ()) {
        let parameter: Parameters = [
            "x": "\(location.longitude)",
            "y": "\(location.latitude)"
        ]
        storeDataService.requestFetchKakaoGeoAddress(parameter: parameter) { result, error in
            if let result = result {
                completion(result)
            }
        }
    }
}
