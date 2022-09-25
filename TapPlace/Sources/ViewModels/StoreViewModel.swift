//
//  StoreViewModel.swift
//  TapPlace
//
//  Created by 박상현 on 2022/09/08.
//

import Foundation
import Alamofire
import Combine
import CoreLocation

class StoreViewModel: ObservableObject {
    //MARK: Singleton Pattern
    let storeDataService = StoreDataService.shared
    
    /// 위치 기반 주변 매장 리스트
    @Published var aroundStoreArray: AroundStoreModel? = nil
    /// 유저 현재 위치의 주소
    @Published var userLocationGeoAddress: String = ""
    /// 단일 스토어 정보
    @Published var singleStoreInfo: StoreInfo? = nil
    
    init() {
        
    }
}

//MARK: - Functions
extension StoreViewModel {
    /**
     * @ 주변 스토어 검색
     * coder : sanghyeon
     */
    func requestAroundStore(location: CLLocationCoordinate2D, pays: [String]) {
        let parameter: Parameters = [
            "x1": "\(location.longitude)",
            "y1": "\(location.latitude)",
            "pays": pays,
            "distance": 1.0,
            "user_id": "\(Constants.keyChainDeviceID)"
        ]
        storeDataService.requestFetchAroundStore(parameter: parameter) { result, error in
            if let result = result {
                self.aroundStoreArray = result
            }
        }
    }

    /**
     * @ 스토어 아이디로 가맹점 정보 요청
     * coder : sanghyeon
     */
    func requestStoreInfo(storeID: String, pays: [String], completion: @escaping (StoreInfo?) -> ()) {
        let parameter: Parameters = [
            "store_id": storeID,
            "user_id": Constants.keyChainDeviceID,
            "pays": pays
        ]
        storeDataService.requestFetchStoreInfo(parameter: parameter) { result, error in
            if let _ = error {
                self.singleStoreInfo = nil
                completion(nil)
            }
            if let result = result {
                self.singleStoreInfo = result
                completion(result)
            }
        }
    }
    
    /**
     * @ 스토어 등록여부 확인
     * coder : sanghyeon
     */
    func requestStoreInfoCheck(searchModel: SearchModel, pays: [String], completion: @escaping ([Feedback]?) -> ()) {
        let parameter: Parameters = [
            "store_id": searchModel.id,
            "phone": searchModel.phone,
            "place_name": searchModel.placeName,
            "category_group_name": searchModel.categoryGroupName,
            "address_name": searchModel.addressName,
            "y": searchModel.y,
            "road_address_name": searchModel.roadAddressName,
            "x": searchModel.x,
            "pays": pays,
            "user_id": Constants.keyChainDeviceID
        ]
        
        storeDataService.requestFetchStoreInfoCheck(parameter: parameter) { result, error in
            if let _ = error {
                completion(nil)
            }
            if let result = result {
                completion(result)
            }
        }
    }
    
    /**
     * @ 카카오 로컬 API로 현재 주소 요청
     * coder : sanghyeon
     */
    func requestGeoAddress(location: CLLocationCoordinate2D) {
        let parameter: Parameters = [
            "x": "\(location.longitude)",
            "y": "\(location.latitude)"
        ]
        storeDataService.requestFetchKakaoGeoAddress(parameter: parameter) { result, error in
            if let result = result {
                if let address = result.documents[0].roadAddress {
                    self.userLocationGeoAddress = "\(address.region2DepthName) \(address.roadName) \(address.mainBuildingNo)"
                } else {
                    let address = result.documents[0].address
                    self.userLocationGeoAddress = "\(address.region2DepthName) \(address.region3DepthName)"
                }
                if let _ = error {
                    self.userLocationGeoAddress = "알 수 없음"
                }
            }
        }
    }
}




//
//
//class StoreViewModel {
//    let storeDataService = StoreDataService.shared
//

//    /**
//     * @ 스토어 아이디로 가맹점 정보 요청
//     * coder : sanghyeon
//     */
//    func requestStoreInfo(storeID: String, pays: [String], completion: @escaping (StoreInfo?) -> ()) {
//        let parameter: Parameters = [
//            "store_id": storeID,
//            "user_id": Constants.keyChainDeviceID,
//            "pays": pays
//        ]
//        storeDataService.requestFetchStoreInfo(parameter: parameter) { result, error in
//            completion(result)
//        }
//    }
//    /**
//     * @ 스토어 등록여부 확인
//     * coder : sanghyeon
//     */
//    func requestStoreInfoCheck(searchModel: SearchModel, pays: [String], completion: @escaping ([Feedback]?) -> ()) {
//        let parameter: Parameters = [
//            "store_id": searchModel.id,
//            "phone": searchModel.phone,
//            "place_name": searchModel.placeName,
//            "category_group_name": searchModel.categoryGroupName,
//            "address_name": searchModel.addressName,
//            "y": searchModel.y,
//            "road_address_name": searchModel.roadAddressName,
//            "x": searchModel.x,
//            "pays": pays,
//            "user_id": Constants.keyChainDeviceID
//        ]
//
//        storeDataService.requestFetchStoreInfoCheck(parameter: parameter) { result, error in
//            completion(result)
//        }
//    }
//    /**
//     * @ 카카오 로컬 API로 현재 주소 요청
//     * coder : sanghyeon
//     */
//    func requestGeoAddress(location: CLLocationCoordinate2D, completion: @escaping (KakaoGeoAddresModel) -> ()) {
//        let parameter: Parameters = [
//            "x": "\(location.longitude)",
//            "y": "\(location.latitude)"
//        ]
//        storeDataService.requestFetchKakaoGeoAddress(parameter: parameter) { result, error in
//            if let result = result {
//                completion(result)
//            }
//        }
//    }
//}
