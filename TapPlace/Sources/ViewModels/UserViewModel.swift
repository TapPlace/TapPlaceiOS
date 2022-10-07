//
//  UserViewModel.swift
//  TapPlace
//
//  Created by 박상현 on 2022/09/08.
//

import Foundation
import Alamofire
import Combine

class UserViewModel {
    let userDataService = UserDataService.shared
    
    /// 유저 즐찾, 피드백, 남은 피드백 카운트
    @Published var userAllCount: UserAllCountModel = UserAllCountModel(bookmarkCount: "0", feedbackCount: "0", remainCount: 0)
    
    
    /**
     * @ 최신 약관 정보 요청
     * coder : sanghyeon
     */
    func requestLatestTerms(checkOnly: Bool = true, completion: @escaping (LatestTermsModel?, Error?) -> ()) {
        var parameter: [String: Any]? = nil
        if !checkOnly {
            parameter = [
                "user_id": "\(Constants.keyChainDeviceID)"
            ]
        }
        userDataService.requestFetchLatestTerms(parameter: parameter, header: Constants().header) { result, error in
            if let error = error {
                completion(nil, error)
            }
            if let result = result {
                completion(result, nil)
            }
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
            let formattedDate = user.birth.toDateString()
            
            parameter = [
                "user_id": user.userID,
                "os": user.os,
                "pays": user.pays,
                "sex" : user.sex,
                "personal_date" : user.personalDate,
                "service_date" : user.serviceDate,
                "marketing_agree": user.marketingAgree,
                "birth": formattedDate ?? "",
                "token": ""
            ]
        }
        
        guard let parameter = parameter else { return }
        userDataService.requestFetchAddUser(parameter: parameter, header: Constants().header) { result, error in
            completion(result)
        }
    }
    
    /**
     * @ 유저 정보 수정
     * coder : sanghyeon
     */
    func updateUserInfo(parameter: [String: Any], completion: @escaping (Bool) -> ()) {
        
    }
    
    /**
     * @ 유저 정보 삭제
     * coder : sanghyeon
     */
    func dropUserInfo(completion: @escaping (Any) -> ()) {
        let parameter: [String: Any] = [
            "user_id": "\(Constants.keyChainDeviceID)"
        ]
        
        
        userDataService.requestFetchDropUser(parameter: parameter, header: Constants().header) { result, error in
            if let error = error {
                print("parameter: \(parameter)\nerror: \(error)")
                completion(error)
            }
            completion(result)
        }
    }
    
    /**
     * @ 유저 즐겨찾기, 피드백, 남은피드백 가져오기
     * coder : sanghyeon
     */
    func requestUserAllCount() {
        userDataService.requestFetchUserAllCount(userID: Constants.keyChainDeviceID) { result in
            self.userAllCount = result
        }
    }
}
