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
    
    //MARK: 결제수단, 관심매장 선택창에서 공통으로 쓰이는 색 정의
    /// 비활성화 프레임 테두리 선
    @nonobjc class var disabledBorderColor: UIColor {
        return UIColor.init(hex: 0xDBDEE8, alpha: 0.5)
    }
    /// 비활성화 텍스트 색상
    @nonobjc class var disabledTextColor: UIColor {
        return UIColor.init(hex: 0xB8BDCC)
    }
    /// 활성화 프레임 테두리 선 색상
    @nonobjc class var activateBorderColor: UIColor {
        return UIColor.init(hex: 0x4E77FB, alpha: 0.6)
    }
    /// 활성화 프레임 배경 색상
    @nonobjc class var activateBackgroundColor: UIColor {
        return UIColor.init(hex: 0x4E77FB, alpha: 0.06)
    }
    /// 비활성화 이미지 TintColor
    @nonobjc class var disabledImageColor: UIColor {
        return UIColor.init(hex: 0xDBDEE8, alpha: 0.6)
    }
    /// 탭바 선택 TintColor
    @nonobjc class var tabBarTintColor: UIColor {
        return .pointBlue
    }
    /// 탭바 미선택 TintColor
    @nonobjc class var tabBarUnTintColor: UIColor {
        return UIColor(red: 0.86, green: 0.87, blue: 0.91, alpha: 1.00)
    }
    
    
    /// 비활성화 그레이
    @nonobjc class var deactiveGray: UIColor {
        return UIColor(red: 0.97, green: 0.97, blue: 0.98, alpha: 1.00)
    }
    
}
