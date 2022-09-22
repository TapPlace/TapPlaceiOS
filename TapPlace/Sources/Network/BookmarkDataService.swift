//
//  BookmarkDataService.swift
//  TapPlace
//
//  Created by 박상현 on 2022/09/22.
//

import Foundation
import Alamofire

struct BookmarkDataService {
    static let shared = BookmarkDataService()
    
    //MARK: URL
    let bookmarkUrl = "\(Constants.tapplaceApiUrl)/bookmark"
    
    /**
     * @ 즐겨찾기 불러오기
     * coder : sanghyeon
     */
    func requestFetchUserBookmark(page: Int = 1, completion: @escaping (BookmarkResponseModel?, Error?) -> ()) {
        let url = "\(bookmarkUrl)/\(Constants.keyChainDeviceID)/\(page)"
        print("*** bookmark api url = \(url)")
        AF.request(url, method: .get, encoding: URLEncoding.default)
            .validate()
            .responseDecodable(of: BookmarkResponseModel.self) { (response) in
                switch response.result{
                case .success(let response):
                    completion(response, nil)
                case .failure(let error):
                    completion(nil, error)
                }
            }
    }
    
    /**
     * @ 즐겨찾기 추가/삭제
     * param : isBookmark = 추가여부 (true=추가, false=삭제)
     * coder : sanghyeon
     */
    func requestFetchToggleBookmark(isBookmark: Bool, parameter: Parameters, completion: @escaping (Bool?, Error?) -> ()) {
        var method: HTTPMethod = .post
        let url = "\(bookmarkUrl)"
        switch isBookmark {
        case true:
            method = .post
        case false:
            method = .delete
        }
        AF.request(url, method: method, encoding: URLEncoding.default)
            .validate()
            .responseDecodable(of: AddBookmarkResponseModel.self) { (response) in
                switch response.result {
                case .success(let result):
                    if result.message == "ok" {
                        completion(true, nil)
                    }
                case .failure(let error):
                    completion(nil, error)
                }
                    
            }
    }
}
