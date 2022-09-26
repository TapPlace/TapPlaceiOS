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
    let storeViewModel = StoreViewModel()
    
    //MARK: Define's
    @Published var dataSource: [Bookmark] = []
    var currentPage: Int = 0
    var isEnd: Bool = false
//    var numberOfBookmarks: Int = 0
//    var listOfBookmarks: [Bookmark]?
}

extension BookmarkViewModel {
    /**
     * @ 북마크 가져오기
     * coder : sanghyeon
     */
    func requestBookmark(page: Int = 1, containFeedback: Bool = false) {
        print("*** BookmarkVM, requestBookmark()")
        if currentPage == page { return }
        bookmarkDataService.requestFetchUserBookmark(page: page, header: Constants().header) { response in
            if let response = response, let bookmarks = response.bookmarks {
                var tempDataSource: [Bookmark] = bookmarks
                let bindingDataSource = tempDataSource
                if containFeedback {
                    tempDataSource.removeAll()
                    if bindingDataSource.count == 0 { return }
                    for i in 0...bindingDataSource.count - 1 {
                        var tempBookmark = bindingDataSource[i]
                        StoreViewModel().requestStoreInfoCheck(searchModel: tempBookmark.convertSearchModel(), pays: StorageViewModel().userFavoritePaymentsString) { result in
                            if let result = result {
                                tempBookmark.feedback = result
                                tempDataSource.append(tempBookmark)
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                if i == bindingDataSource.count - 1 {
                                    self.dataSource = tempDataSource
                                    self.isEnd = response.isEnd
                                    self.currentPage = page
                                }
                            }
                        }
                    }
                }
                
            } else {
                self.dataSource = []
            }
        }
    }
    
    /**
     * @ 북마크 추가/삭제
     * coder : sanghyeon
     */
    func requestToggleBookmark(currentBookmark: Bool, storeID: String, completion: @escaping (Bool?) -> ()) {
        let parameter: [String: Any] = [
            "user_id": "\(Constants.keyChainDeviceID)",
            "store_id": "\(storeID)"
        ]
        bookmarkDataService.requestFetchToggleBookmark(currentBookmark: currentBookmark, parameter: parameter, header: Constants().header) { response in
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
