//
//  NoticeViewModel.swift
//  TapPlace
//
//  Created by 이상준 on 2022/09/16.
//

import Foundation
import UIKit

struct NoticeListViewModel {
    var noticeList: [NoticeModel]
    let isEnd: Bool
}

extension NoticeListViewModel {
    func numberOfRowsInSection(_ section: Int) -> Int {
        return self.noticeList.count
    }
    
    func searchAtIndex(_ index: Int) -> NoticeViewModel {
        let notice = self.noticeList[index]
        return NoticeViewModel(notice)
    }
}

struct NoticeViewModel {
    private let noticeModel: NoticeModel
}

extension NoticeViewModel {
    init(_ noticeModel: NoticeModel) {
        self.noticeModel = noticeModel
    }
}

extension NoticeViewModel {
    var title: String? {
        return self.noticeModel.title
    }
    
    var content: String? {
        return self.noticeModel.content
    }
    
    var writeDate: String? {
        return self.noticeModel.writeDate
    }
}
