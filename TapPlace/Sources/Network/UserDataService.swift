//
//  UserDataService.swift
//  TapPlace
//
//  Created by 박상현 on 2022/09/08.
// 

import Alamofire

struct UserDataService {
    static let shared = UserDataService()
    private let userApiUrl = "\(Constants.tapplaceApiUrl)/user"
    private let userlogApiUrl = "\(Constants.tapplaceApiUrl)/userlog"
    private let userDropApiUrl = "\(Constants.tapplaceApiUrl)/user/drop"
    
    /**
     * @ 최신 약관 정보 요청
     * coder : sanghyeon
     */
    func requestFetchLatestTerms(parameter: [String: String], completion: @escaping (LatestTermsModel?, Error?) -> ()) {
        let url = "\(userlogApiUrl)"
        AF.request(url, method: .post, parameters: parameter, encoding: URLEncoding.default, headers: nil)
            .validate()
            .responseDecodable(of: LatestTermsModel.self) { (response) in
                switch response.result {
                case .success(let response):
                    if response.personalDate.isEmpty || response.serviceDate.isEmpty {
                        completion(nil, nil)
                    } else {
                        completion(response, nil)
                    }
                case .failure(let error):
                    completion(nil, error)
                }
            }
    }
    
    
    /**
     * @ 유저정보 최초설정
     * coder : sanghyeon
     */ 
    func requestFetchAddUser(parameter: [String: Any], payments: [String], completion: @escaping (Any?, Error?) -> ()) {
        let url = "\(userApiUrl)"
        
        AF.request(url, method: .post, parameters: parameter, encoding: URLEncoding.default, headers: nil)
            .validate()
            .response() { (response) in
                switch response.result {
                case .success(let response):
                        completion(response, nil)
                case .failure(let error):
                    completion(nil, error)
                }
            }
    }
    
    /**
     * @ 유저정보 삭제
     * coder : sanghyeon
     */
    func requestFetchDropUser(parameter: [String: Any], completion: @escaping (Bool?, Error?) -> ()) {
        let url = "\(userDropApiUrl)"
        
        AF.request(url, method: .patch, parameters: parameter, encoding: URLEncoding.default, headers: nil)
            .validate()
            .response() { (response) in
//                print("drop user result: \(response.result)")
                switch response.result {
                case .success:
                        completion(true, nil)
                case .failure(let error):
                    completion(nil, error)
                }
            }
    }
}
