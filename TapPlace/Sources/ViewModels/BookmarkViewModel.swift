//
//  BookmarkViewModel.swift
//  TapPlace
//
//  Created by 박상현 on 2022/09/22.
//

import Foundation
import Combine

class BookmarkViewModel {
    let bookmarkDataService = BookmarkDataService.shared
    
    //MARK: Define's
    @Published var dataSource: [Bookmark]? = nil
//    var numberOfBookmarks: Int = 0
//    var listOfBookmarks: [Bookmark]?
}

extension BookmarkViewModel {
    /**
     * @ 북마크 가져오기
     * coder : sanghyeon
     */
    func requestBookmark(page: Int = 1) {
        bookmarkDataService.requestFetchUserBookmark(page: page, header: Constants().header) { response in
            if let response = response {
                self.dataSource = response.bookmarks
            } else {
                self.dataSource = nil
            }
        }
    }
    
    /**
     * @ 북마크 추가/삭제
     * coder : sanghyeon
     */
    func requestToggleBookmark(isBookmark: Bool, storeID: String, completion: @escaping (Bool?) -> ()) {
        let parameter: [String: Any] = [
            "user_id": "\(Constants.keyChainDeviceID)",
            "store_id": "\(storeID)"
        ]
        bookmarkDataService.requestFetchToggleBookmark(isBookmark: isBookmark, parameter: parameter, header: Constants().header) { response in
            if let response = response {
                completion(response)
            }
        }
    }
}


////MARK: - Function's
//extension BookmarkViewModel {
//    /**
//     * @ 유저의 북마크 목록 가져오기
//     * coder : sanghyeon
//     */
//    mutating func requestBookmark(page: Int = 1, completion: @escaping (BookmarkResponseModel?, Error?) -> ()) {
//        bookmarkDataService.requestFetchUserBookmark(page: page, header: Constants().header) { response, error in
//            if let error = error {
//                completion(nil, error)
//            }
//            if let response = response {
//                completion(response, nil)
//            }
//        }
//    }
//    /**
//     * @ 북마크 추가/삭제
//     * coder : sanghyeon
//     */
//    mutating func requestToggleBookmark(isBookmark: Bool, storeID: String, completion: @escaping (Bool?) -> ()) {
//        let parameter: [String: Any] = [
//            "user_id": "\(Constants.keyChainDeviceID)",
//            "store_id": "\(storeID)",
//            "key": "\(Constants.tapplaceApiKey)"
//        ]
//        bookmarkDataService.requestFetchToggleBookmark(isBookmark: isBookmark, parameter: parameter) { response in
//            if let response = response {
//                completion(response)
//            }
//        }
//    }
//}
