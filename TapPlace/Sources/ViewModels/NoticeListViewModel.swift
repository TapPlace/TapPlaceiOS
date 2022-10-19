//
//  NoticeViewModel.swift
//  TapPlace
//
//  Created by 이상준 on 2022/09/16.
//

import Foundation
import Combine

class NoticeListViewModel {
    @Published var noticeList: [NoticeModel] = []
    var isEnd: Bool = true
}

extension NoticeListViewModel {
    func requestNotice(page: String) {
        NoticeDataService().getNotice(page: page) { (notice, isEnd, error) in
            if let notice = notice {
                self.noticeList = notice
                self.isEnd = isEnd
            }
        }
    }
}
