//
//  TermsTableViewCell.swift
//  TapPlace
//
//  Created by 박상현 on 2022/08/25.
//

import UIKit

class TermsTableViewCell: UITableViewCell {
    static let cellId = "termsItem"
    
    func setInitCell(isTerm: Bool, require: Bool?, title: String, link: String) {
        //MARK: 약관에 대한 선택 항목이 아닌가?
        if !isTerm {
            linkButton.isHidden = true
            separatorLine.isHidden = false
            titleLabel.textColor = .init(hex: 0x333333)
            titleLabel.font = .systemFont(ofSize: CommonUtils.resizeFontSize(size: 15), weight: .medium)
        }
        //MARK: 타이틀 설정
        titleLabel.text = title
        //MARK: 필수 항목인가?
        guard let require = require else { return }
        if require {
            requireLabel.text = "[필수]"
            requireLabel.textColor = .pointBlue
        } else {
            requireLabel.text = "[선택]"
            requireLabel.textColor = .black
        }
        //MARK: 링크가 있는가? 없으면 링크버튼 숨김
        if link == "" {
            linkButton.isHidden = true
        }
    }
    
    func setCheck(check: Bool = false) {
        if check {
            checkImageView.tintColor = .pointBlue
        } else {
            checkImageView.tintColor = UIColor.init(hex: 0xE6E6E6)
        }
    }
    
    
    
    let containerView: UIView = {
        let containerView = UIView()
        return containerView
    }()
    let checkImageView: UIImageView = {
        let checkImageView = UIImageView()
        checkImageView.image = UIImage(named: "checkmark")?.withRenderingMode(.alwaysTemplate)
        checkImageView.contentMode = .scaleAspectFit
        return checkImageView
    }()
    let requireLabel: UILabel = {
        let requireLabel = UILabel()
        requireLabel.sizeToFit()
        requireLabel.font = .systemFont(ofSize: CommonUtils.resizeFontSize(size: 15), weight: .medium)
        requireLabel.textColor = .pointBlue
        requireLabel.text = ""
        return requireLabel
    }()
    let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.sizeToFit()
        titleLabel.font = .systemFont(ofSize: CommonUtils.resizeFontSize(size: 15), weight: .regular)
        titleLabel.textColor = .init(hex: 0x4D4D4D)
        titleLabel.text = "Title Label"
        return titleLabel
    }()
    let linkButton: UIButton = {
        let linkButton = UIButton(type: .system)
        linkButton.titleLabel?.font = .systemFont(ofSize: CommonUtils.resizeFontSize(size: 15))
        let text = "보기"
        linkButton.setTitle(text, for: .normal)
        let attributeString = NSMutableAttributedString(string: text)
        attributeString.addAttribute(.underlineStyle , value: 1, range: NSRange.init(location: 0, length: text.count))
        linkButton.titleLabel?.attributedText = attributeString
        linkButton.tintColor = UIColor.init(hex: 0xCCCCCC)
        return linkButton
    }()
    let separatorLine: UIView = {
        let separatorLine = UIView()
        separatorLine.backgroundColor = UIColor.init(hex: 0xdbdee8, alpha: 0.4)
        separatorLine.isHidden = true
        return separatorLine
    }()
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super .init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    func setupCell() {
        //MARK: ViewDefine

        
        
        //MARK: ViewPropertyManual
        
        
        //MARK: AddSubView
        addSubview(containerView)
        containerView.addSubview(checkImageView)
        containerView.addSubview(requireLabel)
        containerView.addSubview(titleLabel)
        containerView.addSubview(linkButton)
        containerView.addSubview(separatorLine)
        
        
        //MARK: ViewContraints
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        checkImageView.snp.makeConstraints {
            $0.width.height.equalTo(CommonUtils.resizeFontSize(size: 14))
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
            $0.width.height.equalTo(40)
            $0.centerY.equalTo(containerView)
        }
        separatorLine.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(containerView)
            $0.height.equalTo(1)
        }
        
        //MARK: ViewAddTarget

        
        //MARK: Delegate
        

    }
    override func prepareForReuse() {
        super.prepareForReuse()
        requireLabel.text = ""
        titleLabel.text = "Title Label"
        linkButton.tintColor = UIColor.init(hex: 0xCCCCCC)
        linkButton.isHidden = false
        separatorLine.isHidden = true
        titleLabel.textColor = .init(hex: 0x4D4D4D)
        titleLabel.font = .systemFont(ofSize: CommonUtils.resizeFontSize(size: 15), weight: .regular)
    }
}
