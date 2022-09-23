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
}
