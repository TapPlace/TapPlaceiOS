//
//  PickViewControllerTitleView.swift
//  TapPlace
//
//  Created by 박상현 on 2022/08/08.
//

import UIKit

protocol TitleViewProtocol {
    func didTapTitleViewSkipButton()
    func didTapTitleViewClearButton()
}

class PickViewControllerTitleView: UIView {
    var delegate: TitleViewProtocol?
    /// 현재 페이지에 따른 프로그레스바 사이즈 변경
    let attributedString = NSMutableAttributedString(string: "")
    let imageAttachment = NSTextAttachment()
    
    /// 현재 페이지에 따른 뷰 변화
    var currentPage: CGFloat = 1 {
        willSet {
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(Int(0.1))) {
                self.progressBar.snp.updateConstraints {
                    $0.width.equalTo(self.frame.size.width * (0.5 * newValue))
                }
                if newValue == 1 {
                    /// 현재 페이지가 1일 경우
                    self.pageOne.backgroundColor = .pointBlue
                    self.pageLabelOne.textColor = .white
                    self.pageLabelOne.text = "1"
                    self.pageLabelTwo.textColor = UIColor(hex: 0xCDD2DF)
                    self.pageLabelTwo.text = "2"
                } else {
                    /// 현재 페이지가 2일 경우
                    self.imageAttachment.image = UIImage(systemName: "checkmark")?.withTintColor(.white)
                    
                    self.attributedString.append(NSAttributedString(attachment: self.imageAttachment))
                    self.pageLabelOne.attributedText = self.attributedString
                    
                    self.pageOne.backgroundColor = .pointBlue
                    self.pageLabelOne.textColor = .white
                    self.pageTwo.backgroundColor = .pointBlue
                    self.pageLabelTwo.textColor = .white
                    self.pageLabelTwo.text = "2"
                }
            }
        }
    }
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
        titleViewText.font = .systemFont(ofSize: CommonUtils().resizeFontSize(size: 18), weight: .regular)
        return titleViewText
    }()
    /// 상단 타이틀 > 뷰 > Skip 버튼
    let skipButton: UIButton = {
        let skipButton = UIButton()
        skipButton.setTitle("다음에 할게요", for: .normal)
        skipButton.setTitleColor(UIColor.pointBlue, for: .normal)
        skipButton.titleLabel?.font = .systemFont(ofSize: CommonUtils().resizeFontSize(size: 14), weight: .regular)
        return skipButton
    }()
    /// 상단 타이틀 > 진행바 뷰
    let progressView: UIView = {
        let progressView = UIView()
        progressView.backgroundColor = UIColor.init(hex: 0xDBDEE8, alpha: 0.4)
        return progressView
    }()
    /// 상단 타이틀 > 진행바 뷰 > 진행바
    let progressBar: UIView = {
        let progressBar = UIView()
        progressBar.backgroundColor = .pointBlue
        return progressBar
    }()
    /// 상단 타이틀 > 페이징 뷰
    let pagingView: UIStackView = {
        let pagingView = UIStackView()
        pagingView.axis = .horizontal
        pagingView.distribution = .fill
        pagingView.alignment = .leading
        pagingView.spacing = 10
        return pagingView
    }()
    /// 상단 타이틀 > 페이징 뷰 > 페이지 1
    let pageOne: UIView = {
        let pageOne = UIView()
        pageOne.layer.cornerRadius = pageOne.layer.frame.size.width / 2
        pageOne.backgroundColor = UIColor.init(hex: 0xDBDEE8, alpha: 0.3)
        return pageOne
    }()
    /// 상단 타이틀 > 페이징 뷰 > 페이지 2
    let pageTwo: UIView = {
        let pageTwo = UIView()
        pageTwo.layer.cornerRadius = pageTwo.layer.frame.size.width / 2
        pageTwo.backgroundColor = UIColor.init(hex: 0xDBDEE8, alpha: 0.3)
        return pageTwo
    }()
    /// 상단 타이틀 > 페이징 뷰 > 페이지 > 텍스트 1
    let pageLabelOne: UILabel = {
        let pageLabelOne = UILabel()
        pageLabelOne.sizeToFit()
        pageLabelOne.font = .systemFont(ofSize: CommonUtils().resizeFontSize(size: 16), weight: .bold)
        return pageLabelOne
    }()
    /// 상단 타이틀 > 페이징 뷰 > 페이지 > 텍스트 2
    let pageLabelTwo: UILabel = {
        let pageLabelTwo = UILabel()
        pageLabelTwo.sizeToFit()
        pageLabelTwo.font = .systemFont(ofSize: CommonUtils().resizeFontSize(size: 16), weight: .bold)
        return pageLabelTwo
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
        descLabel.font = .systemFont(ofSize: CommonUtils().resizeFontSize(size: 16), weight: .regular)
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
        clearButtonText.font = .systemFont(ofSize: CommonUtils().resizeFontSize(size: 16), weight: .regular)
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
        skipButton.addTarget(delegate, action: #selector(didTapSkipButton), for: .touchUpInside)
        clearButton.addTarget(delegate, action: #selector(didTapClearButton), for: .touchUpInside)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(Int(0.1))) {
            self.pageOne.layer.cornerRadius = self.pageOne.frame.size.width / 2
            self.pageTwo.layer.cornerRadius = self.pageTwo.frame.size.width / 2
        }
        

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func didTapSkipButton() {
        print("델리게이트 함수 호출 전")
        delegate?.didTapTitleViewSkipButton()
    }
    @objc func didTapClearButton() {
        print("델리게이트 함수 호출 전")
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
        titleView.addSubview(skipButton)
        addSubview(progressView)
        progressView.addSubview(progressBar)
        addSubview(pagingView)
        pagingView.addArrangedSubview(pageOne)
        pagingView.addArrangedSubview(pageTwo)
        pagingView.addArrangedSubview(spacer)
        pageOne.addSubview(pageLabelOne)
        pageTwo.addSubview(pageLabelTwo)
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
        skipButton.snp.makeConstraints {
            $0.centerY.equalTo(titleViewText)
            $0.trailing.equalToSuperview().offset(-20)
        }
        progressView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(titleView.snp.bottom)
            $0.height.equalTo(2)
        }
        progressBar.snp.makeConstraints {
            $0.top.leading.bottom.equalTo(progressView)
            $0.width.equalTo(50)
        }
        pagingView.snp.makeConstraints {
            $0.top.equalTo(progressView.snp.bottom).offset(25)
            $0.leading.equalTo(titleViewText)
            $0.trailing.equalToSuperview()
            $0.height.equalTo(30)
        }
        pageOne.snp.makeConstraints {
            $0.width.height.equalTo(pagingView.snp.height)
        }
        pageLabelOne.snp.makeConstraints {
            $0.centerX.centerY.equalTo(pageOne)
        }
        pageTwo.snp.makeConstraints {
            $0.width.height.equalTo(pagingView.snp.height)
        }
        pageLabelTwo.snp.makeConstraints {
            $0.centerX.centerY.equalTo(pageTwo)
        }
        descLabel.snp.makeConstraints {
            $0.leading.equalTo(pagingView)
            $0.top.equalTo(pagingView.snp.bottom).offset(25)
        }
        clearButtonIcon.snp.makeConstraints {
            $0.top.equalTo(descLabel.snp.bottom).offset(25)
            $0.leading.equalTo(pagingView)
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
