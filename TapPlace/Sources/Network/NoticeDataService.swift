//
//  NoticeDataService.swift
//  TapPlace
//
//  Created by 이상준 on 2022/09/16.
//

import Foundation
import Alamofire

// MARK: -공지사항 데이터 호출 서비스 로직
class NoticeDataService {
    func getNotice(page: String?, completion: @escaping([NoticeModel]?, Error?) -> ()) {
        let getNoticeURL = "\(Constants.tapplaceApiUrl)/notice/notice/all/\(page ?? "1")"
        AF.request(getNoticeURL, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil)
            .validate()
            .responseDecodable(of: NoticeList.self) { (response) in
                switch response.result{
                case .success(let response):
                    completion(response.notice?.notice, nil)
                case .failure(let error):
                    completion(nil, error)
                    print(error.localizedDescription)
                }
            }
    }
}
