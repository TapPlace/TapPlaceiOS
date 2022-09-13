//
//  PickViewControllerTitleView.swift
//  TapPlace
//
//  Created by 박상현 on 2022/08/08.
//

import UIKit

protocol TitleViewProtocol {
    func didTapTitleViewClearButton()
}

class PickViewControllerTitleView: UIView {
    var delegate: TitleViewProtocol?
    /// 현재 페이지에 따른 프로그레스바 사이즈 변경
    let attributedString = NSMutableAttributedString(string: "")
    let imageAttachment = NSTextAttachment()
    
    /// 상단 타이틀 > 뷰
    let titleView: UIView = {
        let titleView = UIView()
        return titleView
    }()
    /// 상단 타이틀 > 뷰 > 텍스트
    let titleViewText: UILabel = {
        let titleViewText = UILabel()
        titleViewText.sizeToFit()
        titleViewText.text = ""
        titleViewText.textColor = .black
        titleViewText.font = .systemFont(ofSize: CommonUtils.resizeFontSize(size: 18), weight: .regular)
        return titleViewText
    }()

    /// 스택뷰 여백
    let spacer: UIView = {
        let spacer = UIView()
        spacer.isUserInteractionEnabled = false
        spacer.setContentHuggingPriority(.fittingSizeLevel, for: .horizontal)
        spacer.setContentCompressionResistancePriority(.fittingSizeLevel, for: .horizontal)
        return spacer
    }()
    /// 페이지 설명
    let descLabel: UILabel = {
        let descLabel = UILabel()
        descLabel.numberOfLines = 0
        descLabel.text = ""
        descLabel.textColor = UIColor(hex: 0x000000, alpha: 0.5)
        descLabel.font = .systemFont(ofSize: CommonUtils.resizeFontSize(size: 16), weight: .regular)
        return descLabel
    }()
    /// 초기화 버튼 이미지
    let clearButtonIcon: UIImageView = {
        let clearButtonIcon = UIImageView()
        clearButtonIcon.image = UIImage(systemName: "arrow.clockwise")
        clearButtonIcon.contentMode = .scaleAspectFill
        clearButtonIcon.tintColor = UIColor(hex: 0xB8B8B8)
        return clearButtonIcon
    }()
    /// 초기화 버튼 텍스트
    let clearButtonText: UILabel = {
        let clearButtonText = UILabel()
        clearButtonText.text = "초기화"
        clearButtonText.textColor = UIColor(hex: 0x000000, alpha: 0.35)
        clearButtonText.font = .systemFont(ofSize: CommonUtils.resizeFontSize(size: 16), weight: .regular)
        return clearButtonText
    }()
    /// 초기화 버튼
    let clearButton: UIButton = {
        let clearButton = UIButton()
        return clearButton
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        drawingView()
        clearButton.addTarget(delegate, action: #selector(didTapClearButton), for: .touchUpInside)

        

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func didTapClearButton() {
        delegate?.didTapTitleViewClearButton()
    }
    
}

//MARK: - Drawing View
extension PickViewControllerTitleView {
    /**
     * @ 뷰 드로잉 설정
     * coder : sanghyeon
     */
    func drawingView() {
        //MARK: Setup View - 상단 타이틀
        /// 뷰 추가
        addSubview(titleView)
        titleView.addSubview(titleViewText)
        addSubview(descLabel)
        addSubview(clearButtonIcon)
        addSubview(clearButtonText)
        addSubview(clearButton)
        /// 뷰 제약
        titleView.snp.makeConstraints {
            $0.height.equalTo(50)
            $0.top.leading.trailing.equalToSuperview()
        }
        titleViewText.snp.makeConstraints {
            $0.centerY.equalTo(titleView).offset(-5)
            $0.leading.equalToSuperview().offset(20)
        }
        descLabel.snp.makeConstraints {
            $0.leading.equalTo(titleViewText)
            $0.top.equalTo(titleView.snp.bottom).offset(25)
        }
        clearButtonIcon.snp.makeConstraints {
            $0.top.equalTo(descLabel.snp.bottom).offset(25)
            $0.leading.equalTo(descLabel)
            $0.width.height.equalTo(15)
        }
        clearButtonText.snp.makeConstraints {
            $0.leading.equalTo(clearButtonIcon.snp.trailing).offset(3)
            $0.centerY.equalTo(clearButtonIcon)
        }
        clearButton.snp.makeConstraints {
            $0.top.leading.equalTo(clearButtonIcon).offset(-10)
            $0.bottom.equalTo(clearButtonIcon).offset(10)
            $0.trailing.equalTo(clearButtonText).offset(10)
        }
    }
}
