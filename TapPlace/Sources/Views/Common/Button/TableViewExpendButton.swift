//
//  TableViewExpendButton.swift
//  TapPlace
//
//  Created by 박상현 on 2022/09/17.
//

import UIKit

class TableViewExpendButton: UIButton {
    
    override func draw(_ rect: CGRect) {
        self.semanticContentAttribute = .forceRightToLeft
        self.imageEdgeInsets = UIEdgeInsets(top: .zero, left: 5, bottom: .zero, right: .zero)
        self.setImage(UIImage(systemName: "chevron.down"), for: .normal)
        self.setPreferredSymbolConfiguration(.init(pointSize: CommonUtils.resizeFontSize(size: 14), weight: .regular, scale: .default), forImageIn: .normal)
        self.tintColor = .init(hex: 0x333333)
        self.titleLabel?.font = .systemFont(ofSize: CommonUtils.resizeFontSize(size: 14))
    }
}
