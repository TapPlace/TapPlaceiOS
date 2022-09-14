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
    
    func postInquiry(parameter: Parameters, completion: @escaping (String, Error?) -> ()) {
        let url = "\(inquiryURL)"
        AF.request(url, method: .post, parameters: parameter, encoding: URLEncoding.default, headers: nil)
            .responseString { (response) in
                switch response.result {
                case .success(let response):
                    completion("작성완료되었습니다.", nil)
                case .failure(let error):
                    completion("작성 중 오류가 발생했습니다.", error)
                }
            }
    }
}
