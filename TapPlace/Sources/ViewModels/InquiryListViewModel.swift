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
    func numberOfRowsInSection(_ section: Int) -> Int {
        return self.inquiryList.count
    }
    
    func searchAtIndex(_ index: Int) -> InquiryViewModel {
        let inquiry = self.inquiryList[index]
        return InquiryViewModel(inquiry)
    }
}

struct InquiryViewModel {
    private let inquiryModel: InquiryModel
}

extension InquiryViewModel {
    init(_ inquiryModel: InquiryModel) {
        self.inquiryModel = inquiryModel
    }
}

extension InquiryViewModel {
    var title: String? {
        return inquiryModel.title
    }
    
    var content: String? {
        return inquiryModel.content
    }
    
    var writeDate: String? {
        return inquiryModel.writeDate
    }
    
    var answerCheck: Int? {
        return inquiryModel.answerCheck
    }
}
