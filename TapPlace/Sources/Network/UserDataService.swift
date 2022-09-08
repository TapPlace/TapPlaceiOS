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
    func requestFetchAddUser(parameter: [String: Any], payments: [String], completion: @escaping (Any) -> ()) {
        let url = "\(userApiUrl)"
        
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.timeoutInterval = 10
        
        let params = parameter as Dictionary
        
        do {
            try request.httpBody = JSONSerialization.data(withJSONObject: params, options: [])
        } catch {
            print("http Body Error")
        }
        
        AF.request(request).responseString{ (response) in
            switch response.result {
            case .success:
                print("POST 성공")
                completion(response.result)
            case .failure(let error):
                print(error.errorDescription!)
            }
        }
        
    }
}
