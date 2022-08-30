//
//  TermsModel.swift
//  TapPlace
//
//  Created by 박상현 on 2022/08/25.
//

import Foundation

struct TermsModel {
    let title: String
    let isTerm: Bool
    let require: Bool?
    let link: String
    var checked: Bool
    var read: Bool = false
}

extension TermsModel {
    static let lists: [TermsModel] = [
        TermsModel(title: "서비스 이용약관", isTerm: true, require: true, link: "/", checked: false),
        TermsModel(title: "개인정보 수집 및 이용동의", isTerm: true, require: true, link: "/terms/privacy.html", checked: false),
        TermsModel(title: "마케팅 정보 수신 동의", isTerm: true, require: false, link: "", checked: false),
        TermsModel(title: "모두 확인 및 동의합니다.", isTerm: false, require: nil, link: "", checked: false)
    ]
    
}
