//
//  StoreDataService.swift
//  TapPlace
//
//  Created by 박상현 on 2022/09/08.
//

import Alamofire

struct StoreDataService {
    static let shared = StoreDataService()
    private let aroundSearchUrl = "\(Constants.tapplaceApiUrl)/store/around"
    
    
    /**
     * @ 주변 스토어 검색
     * coder : sanghyeon
     */
    func requestFetchAroundStore(parameter: Parameters, completion: @escaping (AroundStoreModel?, Error?) -> ()) {
        let url = "\(aroundSearchUrl)"
        let encoder = URLEncodedFormParameterEncoder(encoder: URLEncodedFormEncoder(arrayEncoding: .noBrackets))
        AF.request(url, method: .post, parameters: parameter, encoding: JSONEncoding.default, headers: nil)
            .validate()
            .responseDecodable(of: AroundStoreModel.self) { (response) in
                switch response.result {
                case .success(let response):
                    completion(response, nil)
                case .failure(let error):
                    completion(nil, error)
                }
            }
    }
}



/*
 
 func requestFetchAroundStore(parameter: Parameters, completion: @escaping (AroundStoreModel?, Error?) -> ()) {
     let url = "\(aroundSearchUrl)"
     AF.request(url, method: .post, parameters: parameter, encoding: URLEncoding.default, headers: nil)
         .validate()
         .responseDecodable(of: AroundStoreModel.self) { (response) in
             switch response.result {
             case .success(let response):
                 completion(response, nil)
             case .failure(let error):
                 completion(nil, error)
             }
         }
 }
 
 */
