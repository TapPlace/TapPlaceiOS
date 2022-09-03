//
//  AroundFilterButton.swift
//  TapPlace
//
//  Created by 박상현 on 2022/08/17.
//

import UIKit

protocol AroundFilterButtonProtocol {
    func didTapAroundFilterButton(_ sender: AroundFilterButton)
}

class AroundFilterButton: UIView {
    var delegate: AroundFilterButtonProtocol?
    var title = "매장선택" {
        willSet {
            buttonLabel.text = newValue
        }
    }
    
    var selectedCount: Int = 0 {
        willSet {
            buttonLabel.text = newValue > 0 ? "\(title) \(newValue)" : title
            buttonFrame.layer.borderWidth = newValue > 0 ? 0 : 1
            buttonFrame.backgroundColor = newValue > 0 ? .pointBlue.withAlphaComponent(0.08) : .white
            buttonLabel.textColor = newValue > 0 ? .pointBlue : .black
            buttonIcon.image = newValue > 0 ? UIImage(systemName: "xmark") : UIImage(systemName: "chevron.down")
            buttonIcon.tintColor = newValue > 0 ? .pointBlue.withAlphaComponent(0.3) : .black
        }
    }
    
    let buttonFrame: UIView = {
        let buttonFrame = UIView()
        buttonFrame.layer.borderWidth = 1
        buttonFrame.layer.borderColor = UIColor.init(hex: 0xdbdee8).cgColor
        return buttonFrame
    }()
    let buttonLabel: UILabel = {
        let buttonLabel = UILabel()
        buttonLabel.text = "매장선택"
        buttonLabel.textColor = .black
        buttonLabel.font = .systemFont(ofSize: CommonUtils.resizeFontSize(size: 12), weight: .regular)
        buttonLabel.sizeToFit()
        return buttonLabel
    }()
    let buttonIcon: UIImageView = {
        let buttonIcon = UIImageView()
        buttonIcon.image = UIImage(systemName: "chevron.down")
        buttonIcon.contentMode = .scaleAspectFit
        buttonIcon.tintColor = .black
        return buttonIcon
    }()
    let button = UIButton()
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(buttonFrame)
        buttonFrame.addSubview(buttonLabel)
        buttonFrame.addSubview(buttonIcon)
        addSubview(button)
        
        button.addTarget(delegate, action: #selector(didTapFilterButton), for: .touchUpInside)
        
        buttonFrame.snp.makeConstraints {
            $0.leading.equalTo(buttonLabel).offset(-15)
            $0.top.bottom.equalToSuperview().inset(-5)
            $0.trailing.equalTo(buttonIcon).offset(15)
        }
        buttonLabel.snp.makeConstraints {
            $0.top.bottom.equalTo(buttonFrame)
            $0.centerY.equalTo(buttonFrame)
        }
        buttonIcon.snp.makeConstraints {
            $0.leading.equalTo(buttonLabel.snp.trailing).offset(5)
            $0.centerY.equalTo(buttonLabel)
            $0.width.equalTo(13)
        }
        button.snp.makeConstraints {
            $0.edges.equalTo(buttonFrame)
        }
        DispatchQueue.main.async {
            self.buttonFrame.layer.cornerRadius = self.buttonFrame.frame.height / 2
        }
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func didTapFilterButton() {
        delegate?.didTapAroundFilterButton(self)
    }
}
