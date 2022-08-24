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
    var isActive: Bool = false
    var delegate: BottomButtonProtocol?
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        drawButton()
        addTarget(self, action: #selector(didTapThisButton), for: .touchUpInside)
    }

}
extension BottomButton {
    func drawButton() {
        self.contentVerticalAlignment = .center
        //self.contentEdgeInsets.top = 18
    }
    @objc func didTapThisButton() {
        delegate?.didTapBottomButton()
    }
}
