//
//  FeedbackViewModel.swift
//  TapPlace
//
//  Created by 박상현 on 2022/09/13.
//

import Foundation
import Alamofire
import Combine

class FeedbackViewModel {
    let feedbackDataService = FeedbackDataService.shared
    
    @Published var remainCount: Int = -1
    @Published var userFeedbackHistory: FeedbackResponseModel?
}

extension FeedbackViewModel {
    /**
     * @ 유저의 피드백 목록 가져오기
     * coder : sanghyeon
     */
    func requestUserFeedback(page: Int = 1) {
        feedbackDataService.requestFetchUserFeedback(page: page) { result in
            if let result = result {
                self.userFeedbackHistory = result
            } else {
                self.userFeedbackHistory = nil
            }
        }
    }
    
    /**
     * @ 유저의 결제수단의 피드백 가져오기
     * coder : sanghyeon
     */
    func requestUserPaymentFeedback(storeInfo: StoreInfo, userPayments: [String], completion: @escaping (LoadFeedbackModel?) -> ()) {
        let parameter: Parameters = [
            "address_name": storeInfo.addressName,
            "category_group_name": storeInfo.categoryGroupName,
            "store_id": storeInfo.storeID,
            "phone": storeInfo.phone,
            "place_name": storeInfo.placeName,
            "x": storeInfo.x,
            "y": storeInfo.y,
            "pays": userPayments,
            "road_address_name": storeInfo.roadAddressName,
            "user_id": Constants.keyChainDeviceID
        ]
        feedbackDataService.requestFetchUserPaymentFeedback(parameter: parameter) { result, error in
            if let result = result {
                completion(result)
            }
        }
    }
    /**
     * @ 유저의 결제수단 외 피드백 가져오기
     * coder : sanghyeon 
     */
    func requestMorePaymentFeedback(storeID: String ,otherPayments: [String], completion: @escaping (LoadFeedbackModel?) -> ()) {
        let parameter: Parameters = [
            "store_id": storeID,
            "pays": otherPayments
        ]
        feedbackDataService.requestFetchMorePaymentFeedback(parameter: parameter) { result, error in
            if let result = result {
                completion(result)
            }
        }
    }
    /**
     * @ 피드백 업데이트
     * coder : sanghyeon
     */
    func requestUpdateFeedback(storeID: String ,feedback: [[LoadFeedbackList]], completion: @escaping (FeedbackResultModel?) -> ()) {
        var requestFeedback: [Parameters] = []
        feedback[0].forEach {
            let tempFeedback = [
                "pay": $0.pay,
                "exist": $0.exist,
                "feed": true
            ] as [String : Any]
            requestFeedback.append(tempFeedback)
        }
        feedback[1].forEach {
            let tempFeedback = [
                "pay": $0.pay,
                "exist": $0.exist,
                "feed": false
            ] as [String : Any]
            requestFeedback.append(tempFeedback)
        }
        let parameter: Parameters = [
            "store_id": storeID,
            "user_feedback": requestFeedback,
            "user_id": Constants.keyChainDeviceID
        ]
        feedbackDataService.requestFetchUpdatetFeedback(parameter: parameter) { result, error in
            print("*** feedback viewmodel request feedback result: \(result)")
            if let result = result {
                completion(result)
            }
        }
    }
    
    /**
     * @ 남은 피드백 확인
     * coder : sanghyeon
     */
    func requestRemainFeedbackCount() {
        feedbackDataService.requestFetchReaminFeedback() { result in
            self.remainCount = result
        }
    }
}
