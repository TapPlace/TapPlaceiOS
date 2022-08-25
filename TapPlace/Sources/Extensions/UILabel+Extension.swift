//
//  UILabel+Extension.swift
//  TapPlace
//
//  Created by 박상현 on 2022/08/25.
//

import UIKit

extension UILabel {
    func lineHeight(height: CGFloat) {
        guard let attributedStr = self.attributedText else { return }
        let attributedString = NSMutableAttributedString(attributedString: attributedStr)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = height
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attributedString.length))
        self.attributedText = attributedString
    }
}
