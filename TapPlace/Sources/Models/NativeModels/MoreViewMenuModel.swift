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
        case notice, version, faq, qna, request, reset
    }
    
    let title: String
    let type: MoreMenuType
    let subTitle: MoreMenuType?
    let vc: UIViewController?
}

extension MoreMenuModel {
    static let list: [MoreMenuModel] = [
        MoreMenuModel(title: "공지사항", type: .notice, subTitle: nil, vc: NoticeViewController()),
        MoreMenuModel(title: "버전정보", type: .version, subTitle: .version, vc: nil),
        MoreMenuModel(title: "자주 묻는 질문", type: .faq, subTitle: nil, vc: nil),
        MoreMenuModel(title: "문의하기", type: .qna, subTitle: nil, vc: InquiryViewController()),
        MoreMenuModel(title: "수정제안", type: .request, subTitle: nil, vc: InquiryViewController()),
        MoreMenuModel(title: "활동내역 초기화", type: .reset, subTitle: nil, vc: nil)
    ]
}