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
    private let termsUrl = "\(Constants.tapplaceApiUrl)/terms"
    
    /**
     * @ 최신 약관 정보 요청
     * coder : sanghyeon
     */
    func requestFetchLatestTerms(parameter: Parameters? = nil, header: HTTPHeaders? = nil, completion: @escaping (LatestTermsModel?, Error?) -> ()) {
        var url = "\(termsUrl)"
        var apiMethod: HTTPMethod = .get
        if let parameter = parameter {
            url = "\(userlogApiUrl)"
            apiMethod = .post
        }
        
        AF.request(url, method: apiMethod, parameters: parameter, encoding: URLEncoding.default, headers: header)
            .validate()
            .responseDecodable(of: LatestTermsModel.self) { (response) in
                print("*** UserDS, requestFetchLatestTerms\n - header: \(header)\n - response: \(response)")
                switch response.result {
                case .success(let response):
                    completion(response, nil)
                case .failure(let error):
                    completion(nil, error)
                }
            }
    }

    /**
     * @ 유저정보 최초설정
     * coder : sanghyeon
     */ 
    func requestFetchAddUser(parameter: [String: Any], header: HTTPHeaders?, completion: @escaping (Any?, Error?) -> ()) {
        let url = "\(userApiUrl)"
        
        AF.request(url, method: .post, parameters: parameter, encoding: JSONEncoding.default, headers: nil)
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
     * @ 유저정보 업데이트
     * coder : sanghyeon
     */
    func requestFetchUpdateUser(parameter: [String: Any], header: HTTPHeaders?, completion: @escaping (Bool) -> ()) {
        let url = "\(userApiUrl)/\(Constants.keyChainDeviceID)"
        AF.request(url, method: .patch, parameters: parameter, encoding: URLEncoding.default, headers: nil)
            .validate()
            .responseDecodable(of: UserUpdateModel.self) { (response) in
                print("*** UserDS, requestFetchUpdateUser\n - response: \(response)")
                switch response.result {
                case .success(let response):
                    if let message = response.message {
                        completion(message == "ok")
                    } else {
                        completion(false)
                    }
                case .failure(let error):
                    completion(false)
                }
            }
    }
    
    /**
     * @ 유저정보 삭제
     * coder : sanghyeon
     */
    func requestFetchDropUser(parameter: [String: Any], header: HTTPHeaders?, completion: @escaping (Bool?, Error?) -> ()) {
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
