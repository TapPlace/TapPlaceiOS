//
//  InquiryService.swift
//  TapPlace
//
//  Created by 이상준 on 2022/09/13.
//

import Foundation
import Alamofire

class InquiryService {
    
    private let inquiryURL = "\(Constants.tapplaceApiUrl)/qna"
    
    // 문의사항 등록 서비스 로직
    func postInquiry(parameter: Parameters, completion: @escaping (Bool?, Error?) -> ()) {
        let url = "\(inquiryURL)"
        AF.request(url, method: .post, parameters: parameter, encoding: URLEncoding.default, headers: nil)
            .validate(statusCode: 200..<300)
            .response { (response) in
                switch response.result {
                case .success(let response):
                    completion(true, nil)
                case .failure(let error):
                    completion(nil, error)
                }
            }
    }
    
    // 문의사항 조회 서비스 로직
    func getInquiries(page: String?, completion: @escaping ([InquiryModel]?, Bool?, Error?) -> ()){
        let url = "\(inquiryURL)/\(Constants.keyChainDeviceID)/\(page ?? "1")"
        AF.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: Constants().header)
            .validate()
            .responseDecodable(of: InquiryList.self) { (response) in
                switch response.result {
                case .success(let response):
                    completion(response.inquiries, response.isEnd, nil)
                case .failure(let error):
                    completion(nil, false, error)
                    print(error.localizedDescription)
                }
            }
    }
}
