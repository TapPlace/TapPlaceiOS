//
//  UserViewModel.swift
//  TapPlace
//
//  Created by 박상현 on 2022/09/08.
//

import Foundation

class UserViewModel {
    let userDataService = UserDataService.shared
    
    /**
     * @ 최신 약관 정보 요청
     * coder : sanghyeon
     */
    func requestLatestTerms(checkOnly: Bool = true, completion: @escaping (LatestTermsModel?, Error?) -> ()) {
        var parameter: [String: Any]? = nil
        if !checkOnly {
            parameter = [
                "user_id": "\(Constants.keyChainDeviceID)",
                "key": "\(Constants.tapplaceApiKey)"
            ]
        }
        userDataService.requestFetchLatestTerms(parameter: parameter) { result, error in
            if let error = error {
                completion(nil, error)
            }
            completion(result, nil)
        }
    }
    

    /**
     * @ 유저 정보 서버로 전송
     * coder : sanghyeon
     */
    func sendUserInfo(user: UserRegisterModel? = nil, parameters: [String: Any]? = nil, completion: @escaping (Any) -> ()) {
        var parameter: [String: Any]? = nil
        if let parameters = parameters {
            parameter = parameters
        } else {
            guard let user = user else { return }
            parameter = [
                "user_id": user.userID,
                "os": user.os,
                "birth": user.birth,
                "pays": user.pays,
                "sex" : user.sex,
                "personal_date" : user.personalDate,
                "service_date" : user.serviceDate,
                "marketing_agree": user.marketingAgree,
                "key": Constants.tapplaceApiKey
            ]
        }
        
        guard let parameter = parameter else { return }
        userDataService.requestFetchAddUser(parameter: parameter) { result, error in
            completion(result)
        }
    }
    
    /**
     * @ 유저 정보 삭제
     * coder : sanghyeon
     */
    func dropUserInfo(completion: @escaping (Any) -> ()) {
        let parameter: [String: Any] = [
            "user_id": "\(Constants.keyChainDeviceID)",
            "key": "\(Constants.tapplaceApiKey)"
        ]
        
        userDataService.requestFetchDropUser(parameter: parameter) { result, error in
            if let error = error {
                completion(error)
            }
            completion(result)
        }
    }
}
