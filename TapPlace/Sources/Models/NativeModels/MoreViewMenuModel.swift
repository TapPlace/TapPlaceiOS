//
//  MoreViewMenuModel.swift
//  TapPlace
//
//  Created by 박상현 on 2022/09/08.
//

import Foundation
import UIKit

struct MoreMenuModel {
    enum MoreMenuType {
        case notice, version, faq, qna, edit, reset, feedback
    }
    
    let title: String
    let type: MoreMenuType
    let subTitle: MoreMenuType?
    let vc: UIViewController?
}

extension MoreMenuModel {
    static let list: [MoreMenuModel] = [
        MoreMenuModel(title: "공지사항", type: .notice, subTitle: nil, vc: NoticeViewController()), // 베타버전 임시 주석
        MoreMenuModel(title: "버전정보", type: .version, subTitle: .version, vc: nil),
        MoreMenuModel(title: "피드백 현황", type: .feedback, subTitle: nil, vc: FeedbackWebViewController()),
//        MoreMenuModel(title: "자주 묻는 질문", type: .faq, subTitle: nil, vc: FAQViewController()), // 베타버전 임시 주석
        MoreMenuModel(title: "문의하기", type: .qna, subTitle: nil, vc: InquiryViewController()),
        MoreMenuModel(title: "수정제안", type: .edit, subTitle: nil, vc: SuggestedViewController())
    ]
}
