//
//  InquiryViewModel.swift
//  TapPlace
//
//  Created by 이상준 on 2022/09/27.
//

import Foundation

struct InquiryListViewModel {
    var inquiryList: [InquiryModel]
    let isEnd: Bool
}

extension InquiryListViewModel {
//    var numberOfSections: Int {
//        return 2
//    }
    
    func numberOfRowsInSection(_ section: Int) -> Int {
        return self.inquiryList.count
    }
    
    func searchAtIndex(_ index: Int) -> InquiryViewModel {
        let inquiry = self.inquiryList[index]
        return InquiryViewModel(inquiry)
    }
}

struct InquiryViewModel {
    private let inquiry: InquiryModel
}

extension InquiryViewModel {
    init(_ inquiry: InquiryModel) {
        self.inquiry = inquiry
    }
}

extension InquiryViewModel {
    var title: String? {
        return inquiry.title
    }
    
    var content: String? {
        return inquiry.content
    }
    
    var writeDate: String? {
        return inquiry.writeDate
    }
    
    var answerCheck: Int? {
        return inquiry.answerCheck
    }
}
