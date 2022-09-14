//
//  TermsItemView.swift
//  TapPlace
//
//  Created by 박상현 on 2022/08/25.
//

import UIKit

protocol TermsItemProtocol {
    func didTapLinkButton(_ sender: UIView)
}

class TermsItemView: UIView {
    var delegate: TermsItemProtocol?

    var checked: Bool = false {
        willSet {
            if newValue {
                checkImageView.image = UIImage(systemName: "checkmark.circle.fill")
                checkImageView.tintColor = .pointBlue
            } else {
                checkImageView.image = UIImage(systemName: "checkmark.circle")
                checkImageView.tintColor = UIColor.init(hex: 0xE6E6E6)
            }
        }
    }
    
    var require: Bool? = nil {
        willSet {
            guard let newRequire = newValue else { return }
            if newRequire != nil {
                if newRequire {
                    requireLabel.text = "[필수]"
                    requireLabel.textColor = .pointBlue
                } else {
                    requireLabel.text = "[선택]"
                    requireLabel.textColor = .black
                }
            }
            
        }
    }
    
    var link: String? = "" {
        willSet {
            if newValue == "" {
                linkButton.isHidden = true
            }
        }
    }
    
    var titleText: String = "TitleLabel" {
        willSet {
            titleLabel.text = newValue
        }
    }
    
    let checkImageView: UIImageView = {
        let checkImageView = UIImageView()

        return checkImageView
    }()
    let requireLabel: UILabel = {
        let requireLabel = UILabel()
        requireLabel.sizeToFit()
        requireLabel.font = .systemFont(ofSize: CommonUtils.resizeFontSize(size: 15), weight: .regular)
        requireLabel.textColor = .pointBlue
        requireLabel.text = ""
        return requireLabel
    }()
    let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.sizeToFit()
        titleLabel.font = .systemFont(ofSize: CommonUtils.resizeFontSize(size: 15), weight: .regular)
        titleLabel.textColor = .black
        titleLabel.text = "Title Label"
        return titleLabel
    }()
    let linkButton: UIButton = {
        let linkButton = UIButton()
        linkButton.titleLabel?.font = .systemFont(ofSize: CommonUtils.resizeFontSize(size: 15))
        let text = "보기"
        linkButton.setTitle(text, for: .normal)
        let attributeString = NSMutableAttributedString(string: text)
        attributeString.addAttribute(.underlineStyle , value: 1, range: NSRange.init(location: 0, length: text.count))
        linkButton.titleLabel?.attributedText = attributeString
        linkButton.tintColor = UIColor.init(hex: 0xCCCCCC)
        return linkButton
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension TermsItemView {
    /**
     * @ 초기 레이아웃 설정
     * coder : sanghyeon
     */
    func setupView() {
        //MARK: ViewDefine
        let containerView: UIView = {
            let containerView = UIView()
            return containerView
        }()

        
        
        //MARK: ViewPropertyManual
        
        
        //MARK: AddSubView
        addSubview(containerView)
        containerView.addSubview(checkImageView)
        containerView.addSubview(requireLabel)
        containerView.addSubview(titleLabel)
        containerView.addSubview(linkButton)
        
        
        //MARK: ViewContraints
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        checkImageView.snp.makeConstraints {
            $0.width.height.equalTo(25)
            $0.leading.equalTo(containerView)
            $0.centerY.equalTo(containerView)
        }
        requireLabel.snp.makeConstraints {
            $0.leading.equalTo(checkImageView.snp.trailing).offset(10)
            $0.centerY.equalTo(containerView)
        }
        titleLabel.snp.makeConstraints {
            $0.leading.equalTo(requireLabel.snp.trailing).offset(5)
            $0.centerY.equalTo(requireLabel)
        }
        linkButton.snp.makeConstraints {
            $0.trailing.equalTo(containerView)
            $0.width.height.equalTo(50)
        }
        
        //MARK: ViewAddTarget

        
        //MARK: Delegate
    }
    
}
