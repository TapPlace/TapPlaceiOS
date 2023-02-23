//
//  CustomNavigationBar.swift
//  TapPlace
//
//  Created by 박상현 on 2022/09/05.
//

import UIKit

protocol CustomNavigationBarProtocol {
    func didTapLeftButton()
}

class CustomNavigationBar: UIView {
    //MARK: Delegate Degfine
    var delegate: CustomNavigationBarProtocol?
    //MARK: CustomNavigationBar Custom Property
    /**
     * @ 네비게이션 높이 지정 (기본 = 60)
     * coder : sanghyeon
     */
    var navigationHeight: Int = 60 {
        willSet {
            self.containerView.snp.updateConstraints { make in
                make.height.equalTo(newValue)
            }
        }
    }
    /**
     * @ 네비게이션 타이틀 텍스트 지정
     * coder : sanghyeon
     */
    var titleText: String = "" {
        willSet {
            navigationTitleLabel.text = newValue
        }
    }
    /**
     * @ 네비게이션 타이틀 표시 여부 (기본값 = true)
     * coder : sanghyeon
     */
    var isVisibleTitleLabel: Bool = true {
        willSet {
            if !newValue {
                navigationTitleLabel.removeFromSuperview()
            }
        }
    }
    /**
     * @ 네비게이션 하단 그림자 생성 여부
     * coder : sanghyeon
     */
    var isDrawShadow: Bool = false {
        willSet {
            if newValue {
                self.layer.applySketchShadow(color: .black, alpha: 0.12, x: 0, y: 4, blur: 8, spread: 0)
            } else {
                self.layer.applySketchShadow(color: .black, alpha: 0, x: 0, y: 0, blur: 0, spread: 0)
            }
        }
    }
    /**
     * @ 네비게이션 하단 선 생성 여부
     * coder : sanghyeon
     */
    var isDrawBottomLine: Bool = false {
        willSet {
            if newValue {
                self.addSubview(bottomLine)
                self.bottomLine.snp.makeConstraints { make in
                    make.height.equalTo(1)
                    make.leading.trailing.bottom.equalToSuperview()
                }
            } else {
                self.bottomLine.removeFromSuperview()
            }
        }
    }
    /**
     * @ 네비게이션 좌측 버튼 생성 여부
     * coder : sanghyeon
     */
    var isUseLeftButton: Bool = false {
        willSet {
            if newValue {
                self.addSubview(leftButton)
                self.leftButton.snp.makeConstraints { make in
                    make.leading.equalTo(containerView).offset(10)
                    make.bottom.equalTo(containerView).offset(-10)
                    make.width.height.equalTo(30)
                }
                self.navigationTitleLabel.snp.remakeConstraints { make in
                    make.leading.equalTo(leftButton.snp.trailing).offset(5)
                    make.bottom.equalTo(containerView).offset(-15)
                }
                self.leftButton.addTarget(self, action: #selector(didTapLeftButton), for: .touchUpInside)
            }
        }
    }
    /**
     * @ 네비게이션 좌측 버튼 이미지 변경 (기본 = chevron.left)
     * coder : sanghyeon
     */
    var leftButtonImage: UIImage = UIImage(systemName: "chevron.left")! {
        willSet {
            leftButton.setImage(newValue, for: .normal)
        }
    }
    
    let containerView: UIView = {
        let containerView = UIView()
        return containerView
    }()
    
    let bottomLine: UIView = {
        let bottomLine = UIView()
        bottomLine.backgroundColor = .init(hex: 0xDBDEE8, alpha: 0.4)
        return bottomLine
    }()
    
    let leftButton: UIButton = {
        let leftButton = UIButton()
        leftButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        leftButton.tintColor = .black
        return leftButton
    }()
    
    
    
    
    let navigationTitleLabel: UILabel = {
        let navigationTitleLabel = UILabel()
        navigationTitleLabel.sizeToFit()
        navigationTitleLabel.textColor = .black
        navigationTitleLabel.font = .systemFont(ofSize: CommonUtils.resizeFontSize(size: 18), weight: .semibold)
        return navigationTitleLabel
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CustomNavigationBar {
    /**
     * @ 초기 레이아웃 설정
     * coder : sanghyeon
     */
    func setupView() {
        //MARK: ViewDefine
        let safeArea = self.safeAreaLayoutGuide
        
        
        //MARK: ViewPropertyManual
        self.backgroundColor = .white
        self.layer.applySketchShadow(color: .black, alpha: 0, x: 0, y: 0, blur: 0, spread: 0)
        
        //MARK: AddSubView
        self.addSubview(containerView)
        containerView.addSubview(navigationTitleLabel)
        
        
        //MARK: ViewContraints
        containerView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(safeArea)
            $0.height.equalTo(60)
        }
        navigationTitleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.bottom.equalTo(containerView).offset(-15)
        }
        
        //MARK: ViewAddTarget
        
        
        //MARK: Delegate
    }
    /**
     * @ 네비게이션 왼쪽 버튼 클릭 함수
     * coder : sanghyeon
     */
    @objc func didTapLeftButton() {
        guard let delegate = delegate else { return }
        delegate.didTapLeftButton()
    }
}
