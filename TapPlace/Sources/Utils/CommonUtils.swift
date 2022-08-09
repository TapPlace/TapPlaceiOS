//
//  CommonUtils.swift
//  TapPlace
//
//  Created by 박상현 on 2022/08/08.
//

import UIKit

struct CommonUtils {
    /**
     * @ 해상도 비율에 따라 폰트사이즈 동기화
     * 13Pro 해상도 기준 390
     * coder : sanghyeon
     */
    func resizeFontSize(size: CGFloat) -> CGFloat {
        let screenSize: CGRect = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let sizeFormatter = size/390
        return screenWidth * sizeFormatter
    }
    /**
     * @ 결제수단 선택창 셀 크기 지정을 위해 글자수 기반 사이즈 반환
     * coder : sanghyeon
     */
    func getTextSizeWidth(text: String) -> CGFloat {
        let label: UILabel = {
            let label = UILabel()
            label.text = text
            label.font = .systemFont(ofSize: CommonUtils().resizeFontSize(size: 14), weight: .regular)
            label.sizeToFit()
            return label
        }()
        return label.frame.width + 40
    }
}
