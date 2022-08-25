//
//  TermsModel.swift
//  TapPlace
//
//  Created by 박상현 on 2022/08/25.
//

import Foundation

struct TermsModel {
    let title: String
    let require: Bool
    let link: String
}

extension TermsModel {
    static let lists: [TermsModel] = [
        TermsModel(title: "서비스 이용약관", require: true, link: "/"),
        TermsModel(title: "개인정보 수집 및 이용동의", require: true, link: "/"),
        TermsModel(title: "마케팅 정보 수신 동의", require: false, link: "/")
    ]
}
