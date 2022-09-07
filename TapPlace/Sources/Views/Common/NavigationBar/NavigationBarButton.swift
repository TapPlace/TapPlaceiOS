//
//  NAvigationBarButton.swift
//  TapPlace
//
//  Created by 박상현 on 2022/09/06.
//

import UIKit

protocol NavigationBarButtonProtocol {
    func didTapNavigationBarButton(_ sender: UIButton)
}

extension UIButton {
    func setImage(named: String) {
        contentHorizontalAlignment = .fill
        contentVerticalAlignment = .fill
        
        imageView?.contentMode = .scaleAspectFit
        imageEdgeInsets = .zero
        
        setImage(UIImage(named: named), for: .normal)
    }
}

class NavigationBarButton: UIButton {
    
    var delegate: NavigationBarButtonProtocol?
    
    var setImage: String = "" {
        willSet {
            self.setImage(named: newValue)
        }
    }
    
    override func draw(_ rect: CGRect) {
        self.tintColor = .init(hex: 0xDBDEE8)
        self.addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside)
    }
    
    @objc func didTapButton(_ sender: UIButton) {
        delegate?.didTapNavigationBarButton(sender)
    }


}
