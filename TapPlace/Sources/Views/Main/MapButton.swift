//
//  MapButton.swift
//  TapPlace
//
//  Created by 박상현 on 2022/08/14.
//

import UIKit

protocol MapButtonProtocol {
    func didTapMapButton(_ sender: MapButton)
}

class MapButton: UIView {
    var delegate: MapButtonProtocol?
    var iconName: String = "" {
        willSet {
            let iconConfig = UIImage.SymbolConfiguration(pointSize: 24, weight: .medium, scale: .medium)
            buttonImage.image = UIImage(systemName: newValue, withConfiguration: iconConfig)
        }
    }
    
    let buttonFrame: UIView = {
        let buttonFrame = UILabel()
        buttonFrame.backgroundColor = .white
        return buttonFrame
    }()
    
    let buttonImage: UIImageView = {
        let buttonImage = UIImageView()
        buttonImage.tintColor = .pointBlue
        return buttonImage
    }()
    
    let button: UIButton = {
        let button = UIButton()
        return button
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
        DispatchQueue.main.async {
            self.buttonFrame.layer.masksToBounds = true
            self.buttonFrame.layer.cornerRadius = self.buttonFrame.frame.size.width / 2
        }
        button.addTarget(self, action: #selector(didTestTap(_:)), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupButton() {
        addSubview(buttonFrame)
        buttonFrame.addSubview(buttonImage)
        addSubview(button)
        
        buttonFrame.snp.makeConstraints {
            $0.top.bottom.leading.trailing.equalToSuperview()
        }
        buttonImage.snp.makeConstraints {
            $0.centerX.centerY.equalTo(buttonFrame)
            $0.width.height.equalTo(20)
        }
        button.snp.makeConstraints {
            $0.top.bottom.leading.trailing.equalTo(buttonFrame)
        }
    }

    @objc func didTestTap(_ sender: MapButton) {
        delegate?.didTapMapButton(sender)
    }
}
