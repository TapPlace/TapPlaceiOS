
//
//  StoreDataService.swift
//  TapPlace
//
//  Created by 박상현 on 2022/09/08.
//

import Alamofire

struct FeedbackDataService {
    static let shared = FeedbackDataService()
    private let loadFeedbackUrl = "\(Constants.tapplaceApiUrl)/pay/list/check"
    private let loadMoreFeedbackUrl = "\(Constants.tapplaceApiUrl)/pay/list/more"
    private let updateFeedbackUrl = "\(Constants.tapplaceApiUrl)/pay/feedback"
    private let feedbackCountUrl = "\(Constants.tapplaceApiUrl)/feedback-count"
    
    /**
     * @ 유저의 결제수단 피드백 목록 가져오기
     * coder : sanghyeon
     */
    func requestFetchUserPaymentFeedback(parameter: Parameters, completion: @escaping (LoadFeedbackModel?, Error?) -> ()) {
        let url = "\(loadFeedbackUrl)"
        AF.request(url, method: .post, parameters: parameter, encoding: JSONEncoding.default, headers: nil)
            .validate()
            .responseDecodable(of: LoadFeedbackModel.self) { (response) in
                switch response.result {
                case .success(let response):
                    completion(response, nil)
                case .failure(let error):
                    completion(nil, error)
                }
            }
    }
    /**
     * @ 유저의 결제수단 외 피드백 목록 가져오기
     * coder : sanghyeon
     */
    func requestFetchMorePaymentFeedback(parameter: Parameters, completion: @escaping (LoadFeedbackModel?, Error?) -> ()) {
        let url = "\(loadMoreFeedbackUrl)"
        AF.request(url, method: .post, parameters: parameter, encoding: JSONEncoding.default, headers: nil)
            .validate()
            .responseDecodable(of: LoadFeedbackModel.self) { (response) in
                switch response.result {
                case .success(let response):
                    completion(response, nil)
                case .failure(let error):
                    completion(nil, error)
                }
            }
    }
    
    /**
     * @  피드백 업데이트
     * coder : sanghyeon
     */
    func requestFetchUpdatetFeedback(parameter: Parameters, completion: @escaping (FeedbackResultModel?, Error?) -> ()) {
        let url = "\(updateFeedbackUrl)"
        AF.request(url, method: .patch, parameters: parameter, encoding: JSONEncoding.default, headers: nil)
            .validate()
            .responseDecodable(of: FeedbackResultModel.self) { (response) in
                switch response.result {
                case .success(let response):
                    completion(response, nil)
                case .failure(let error):
                    completion(nil, error)
                }
            }
    }
    
    /**
     * @ 남은 피드백 확인
     * coder : sanghyeon
     */
    func requestFetchReaminFeedback(completion: @escaping (Int) -> ()) {
        let url = "\(feedbackCountUrl)/\(Constants.keyChainDeviceID)"
        AF.request(url, method: .get, encoding: URLEncoding.default)
            .validate()
            .responseDecodable(of: FeedbackReamainModel.self) { (response) in
                switch response.result {
                case .success(let response):
                    completion(response.remainCount)
                case .failure(let error):
                    completion(0)
                }
            }
        
        
    }
}
