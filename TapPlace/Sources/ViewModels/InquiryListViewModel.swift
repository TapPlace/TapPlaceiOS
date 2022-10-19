//
//  InquiryViewModel.swift
//  TapPlace
//
//  Created by 이상준 on 2022/09/27.
//

import Foundation
import Combine

class InquiryListViewModel {
    @Published var inquiryList: [InquiryModel] = []
    var isEnd: Bool = true
}

extension InquiryListViewModel {
    func requestInquiry(page: String) {
        InquiryService().getInquiries(page: page) { (inquiry, isEnd, error) in
            if let inquiry = inquiry {
                self.inquiryList = inquiry
                self.isEnd = isEnd
            }
        }
    }
}
