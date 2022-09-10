//
//  BottomButton.swift
//  TapPlace
//
//  Created by 박상현 on 2022/08/09.
//

import UIKit

protocol BottomButtonProtocol {
    func didTapBottomButton()
}

class BottomButton: UIButton {
    
    enum ButtonStyle {
        case activate
        case disabled
    }
    
    func setButtonStyle(title: String, type: ButtonStyle, fill: Bool) {
        self.setTitle(title, for: .normal)
        if type == .activate {
            self.backgroundColor = .pointBlue
            self.setTitleColor(.white, for: .normal)
            self.isActive = true
        } else {
            self.backgroundColor = .deactiveGray
            self.setTitleColor(UIColor.init(hex: 0xAFB4C3), for: .normal)
            self.isActive = false
        }
        
        if fill {
            self.contentVerticalAlignment = .top
            self.contentEdgeInsets.top = 14
        } else {
            self.contentEdgeInsets.top = 0
        }
    }
    
    
    var isActive: Bool = false
    var delegate: BottomButtonProtocol?
    
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        addTarget(self, action: #selector(didTapThisButton), for: .touchUpInside)
    }

}
extension BottomButton {
    @objc func didTapThisButton() {
        delegate?.didTapBottomButton()
    }
}
