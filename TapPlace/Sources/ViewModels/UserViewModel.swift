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
    func requestLatestTerms(uuid: String, completion: @escaping (LatestTermsModel?) -> ()) {
        let parameter: [String: String] = [
            "user_id": "\(Constants.userDeviceID)",
            "key": "\(Constants.tapplaceApiKey)"
        ]
        
        userDataService.requestFetchLatestTerms(parameter: parameter) { result, error in
            completion(result)
        }
    }
    
    /**
     * @ 유저 정보 서버로 전송
     * coder : sanghyeon
     */
    func sendUserInfo(user: UserModel, payments: [String], completion: @escaping (Any) -> ()) {
        let parameter: [String: Any] = [
            "user_id": "\(Constants.userDeviceID)",
            "os": "ios",
            "birth": "\(user.birth)",
            "pays": payments,
            "sex": "\(user.sex)",
            "key": "\(Constants.tapplaceApiKey)"
        ]
        
        userDataService.requestFetchAddUser(parameter: parameter, payments: payments) { result, error in
            completion(result)
        }
    }
    
    /**
     * @ 유저 정보 삭제
     * coder : sanghyeon
     */
    func dropUserInfo(completion: @escaping (Any) -> ()) {
        let parameter: [String: Any] = [
            "user_id": "\(Constants.userDeviceID)",
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
