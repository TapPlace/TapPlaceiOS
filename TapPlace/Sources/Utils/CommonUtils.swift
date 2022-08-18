//
//  CommonUtils.swift
//  TapPlace
//
//  Created by 박상현 on 2022/08/08.
//

import UIKit

struct CommonUtils {
    /**
     * @ 디바이스 고유 UUID 가져오기
     * coder : sanghyeon
     */
    static func getDeviceUUID() -> String {
        return UIDevice.current.identifierForVendor!.uuidString
    }
    
    /**
     * @ 해상도 비율에 따라 폰트사이즈 동기화
     * 13Pro 해상도 기준 390
     * coder : sanghyeon
     */
    static func resizeFontSize(size: CGFloat) -> CGFloat {
        let standatdScreenSize: CGRect = CGRect(x: 0, y: 0, width: 375, height: 812)
        let screenSize: CGRect = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let sizeFormatter = size/375
        return screenWidth < standatdScreenSize.width ? screenWidth * sizeFormatter : size
    }
    
    /**
     * @ 결제수단 선택창 셀 크기 지정을 위해 글자수 기반 사이즈 반환
     * coder : sanghyeon
     */
    static func getTextSizeWidth(text: String) -> LabelSize {
        let label: UILabel = {
            let label = UILabel()
            label.text = text
            label.font = .systemFont(ofSize: CommonUtils.resizeFontSize(size: 14), weight: .regular)
            label.sizeToFit()
            return label
        }()
        return LabelSize(width: label.frame.width, height: label.frame.height)
    }
    

}

struct LabelSize {
    let width: CGFloat
    let height: CGFloat
}
