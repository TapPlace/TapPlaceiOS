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
            .responseString { (response) in
//                print(response.result)
                switch response.result {
                case .success(let response):
                    if response == "true" {
                        completion(true, nil)
                    } else {
                        completion(false, nil)
                    }
                case .failure(let error):
                    completion(nil, error)
                }
            }
    }
}
