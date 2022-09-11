//
//  SearchService.swift
//  TapPlace
//
//  Created by 이상준 on 2022/09/09.
//

import Alamofire
import Foundation

class SearchService {
    static let shared = StoreDataService()
    private let aroundSearchUrl = "\(Constants.tapplaceApiUrl)/store/around"
    private let kakaoGeoUrl = "https://dapi.kakao.com/v2/local/geo/coord2address.json"
    
    func getPlace(url: URL, completion:@escaping(SearchModel?, Error?) -> ()){
        AF.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil)
            .validate()
            .responseDecodable(of: SearchModel.self) { (response) in
                switch response.result {
                case .success(let response):
                    completion(response, nil)
                case .failure(let error):
                    completion(nil, error)
                }
            }
        
    }
}


