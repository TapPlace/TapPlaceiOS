//
//  FeedbackRequestModel.swift
//  TapPlace
//
//  Created by 박상현 on 2022/09/07.
//

import Foundation

struct FeedbackRequestModel {
    enum SelectPaymentFeedback {
        case success, fail
    }
    
    let payment: PaymentModel?
    let selected: SelectPaymentFeedback?
}
