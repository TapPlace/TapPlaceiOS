//
//  MapFloatingButton.swift
//  TapPlace
//
//  Created by 박상현 on 2022/08/14.
//

import UIKit

protocol MapFloatingButtonProtocol {
    func didTapMapFloatingButton(_ sender: UIButton)
}

class MapFloatingButton: UIButton {
    var delegate: MapFloatingButtonProtocol?
    var iconName: String = "" {
        willSet {
            let iconConfig = UIImage.SymbolConfiguration(pointSize: 24, weight: .medium, scale: .medium)
            iconImage.image = UIImage(systemName: newValue, withConfiguration: iconConfig)
        }
    }

    let iconImage: UIImageView = {
        let iconImage = UIImageView()
        iconImage.tintColor = .pointBlue
        return iconImage
    }()
    
    override func draw(_ rect: CGRect) {
        layer.cornerRadius = 20
        backgroundColor = .white
        addTarget(delegate, action: #selector(didTapMapFloatingButton(_:)), for: .touchUpInside)
        addSubview(iconImage)
        iconImage.snp.makeConstraints {
            $0.width.height.equalTo(20)
            $0.centerX.centerY.equalToSuperview()
        }
    }
    
    @objc func didTapMapFloatingButton(_ sender: UIButton) {
        delegate?.didTapMapFloatingButton(sender)
    }
}

