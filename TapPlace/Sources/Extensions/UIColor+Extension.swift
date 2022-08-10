//
//  UIColor+Exrtension.swift
//  TapPlace
//
//  Created by 박상현 on 2022/08/08.
//

import UIKit

extension UIColor {
    //MARK: hex code를 이용하여 정의
    //먼데이 샐리 차용
    //ex. UIColor(hex: 0xF5663F)
    convenience init(hex: UInt, alpha: CGFloat = 1.0) {
        self.init(
            red: CGFloat((hex & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((hex & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(hex & 0x0000FF) / 255.0,
            alpha: CGFloat(alpha)
        )
    }
    
    //MARK: 메인 브랜드 컬러 및 자주 사용되는 색 정의
    /// 브랜드 컬러
    @nonobjc class var pointBlue: UIColor {
        return UIColor(red: 0.31, green: 0.47, blue: 0.98, alpha: 1.00)
    }
    /// 비활성화 그레이
    @nonobjc class var deactiveGray: UIColor {
        return UIColor(red: 0.97, green: 0.97, blue: 0.98, alpha: 1.00)
    }
    
}
