//
//  FeedbackButton.swift
//  TapPlace
//
//  Created by 박상현 on 2022/09/07.
//

import UIKit



class FeedbackButton: UIView {
    enum FeedbackButtonStyle {
        case base, success, fail
    }

    var buttonFrame = UIView()
    var buttonLabel = UILabel()
    var button = UIButton()
    
    var title: String = "" {
        willSet {
            buttonLabel.text = newValue
        }
    }
    
    var setButtonStyle: FeedbackButtonStyle = .base {
        willSet {
            switch newValue {
            case .success:
                buttonFrame.layer.borderColor = UIColor.pointBlue.cgColor
                buttonLabel.textColor = .pointBlue
            case .fail:
                buttonFrame.layer.borderColor = UIColor.pointRed.cgColor
                buttonLabel.textColor = .pointRed
            default:
                buttonFrame.layer.borderColor = UIColor.defaultGray.cgColor
                buttonLabel.textColor = .init(hex: 0x9e9e9e)
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension FeedbackButton {
    /**
     * @ 초기 레이아웃 설정
     * coder : sanghyeon
     */
    func setupView() {
        //MARK: ViewDefine
        buttonFrame = {
            let buttonFrame = UIView()
            buttonFrame.layer.borderWidth = 1
            buttonFrame.layer.borderColor = UIColor.init(hex:0xDBDEE8).cgColor
            buttonFrame.layer.cornerRadius = 8
            return buttonFrame
        }()
        buttonLabel = {
            let buttonLabel = UILabel()
            buttonLabel.sizeToFit()
            buttonLabel.font = .systemFont(ofSize: CommonUtils.resizeFontSize(size: 12), weight: .medium)
            buttonLabel.textColor = .init(hex: 0x9e9e9e)
            return buttonLabel
        }()
        button = {
            let button = UIButton()
            return button
        }()
        
        
        //MARK: ViewPropertyManual
        
        
        //MARK: AddSubView
        self.addSubview(buttonFrame)
        buttonFrame.addSubview(buttonLabel)
        buttonFrame.addSubview(button)
        
        
        //MARK: ViewContraints
        buttonFrame.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        buttonLabel.snp.makeConstraints {
            $0.leading.equalTo(buttonFrame).offset(10)
            $0.trailing.equalTo(buttonFrame).offset(-10)
            $0.centerY.equalTo(buttonFrame)
        }
        button.snp.makeConstraints {
            $0.edges.equalTo(buttonFrame)
        }
        
        
        //MARK: ViewAddTarget
        
        
        //MARK: Delegate
    }
}
