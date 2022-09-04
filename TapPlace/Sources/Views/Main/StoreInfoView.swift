//
//  StoreInfoView.swift
//  TapPlace
//
//  Created by 박상현 on 2022/09/04.
//

import UIKit

protocol StoreInfoViewButtonProtocol {
    func didTapStoreInfoButton(selectedIndex: Int?)
}

class StoreInfoView: UIView {
    var delegate: StoreInfoViewButtonProtocol?
    
    var payLists: [String] = [] {
        willSet {
            payLists = newValue
            addPayBrand(pays: newValue)
        }
    }
    
    var isButtonVisible = false {
        willSet {
            if newValue {
                rightButton.isHidden = false
            } else {
                rightButton.isHidden = true
            }
        }
    }
    
    var thisIndex: Int?
    
    let containerView: UIView = {
        let containerView = UIView()
        return containerView
    }()
    let storeLabel: UILabel = {
        let storeLabel = UILabel()
        storeLabel.sizeToFit()
        storeLabel.text = "가맹점 이름"
        storeLabel.textColor = .black
        storeLabel.font = .systemFont(ofSize: CommonUtils.resizeFontSize(size: 16), weight: .regular)
        return storeLabel
    }()
    let storeDetailLabel: UILabel = {
        let storeDetailLabel = UILabel()
        storeDetailLabel.font = .systemFont(ofSize: CommonUtils.resizeFontSize(size: 12), weight: .regular)
        storeDetailLabel.textColor = UIColor.init(hex: 0x9a9fb0)
        return storeDetailLabel
    }()
    let rightButton: UIButton = {
        let rightButton = UIButton()
        rightButton.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
        rightButton.tintColor = UIColor.init(hex: 0xdbdee8)
        return rightButton
    }()
    let brandStackView: UIStackView = {
        let brandStackView = UIStackView()
        brandStackView.axis = .horizontal
        brandStackView.alignment = .center
        brandStackView.distribution = .fill
        brandStackView.spacing = 4
        return brandStackView
    }()
    let spacerView: UIView = {
        let spacerView = UIView()
        spacerView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return spacerView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension StoreInfoView {
    /**
     * @ 초기 레이아웃 설정
     * coder : sanghyeon
     */
    func setupView() {
        //MARK: ViewDefine
        
        
        //MARK: ViewPropertyManual
        
        
        //MARK: AddSubView
        addSubview(containerView)
        containerView.addSubview(storeLabel)
        containerView.addSubview(storeDetailLabel)
        containerView.addSubview(rightButton)
        containerView.addSubview(brandStackView)
        
        //MARK: ViewContraints
        containerView.snp.makeConstraints {
            //$0.bottom.equalTo(brandStackView)
            $0.leading.centerY.trailing.equalToSuperview()
            $0.top.bottom.equalToSuperview().inset(15)
            
        }
        storeLabel.snp.makeConstraints {
            $0.leading.equalTo(containerView)
            $0.top.equalTo(containerView)
        }
        storeDetailLabel.snp.makeConstraints {
            $0.leading.equalTo(storeLabel)
            $0.top.equalTo(storeLabel.snp.bottom).offset(4)
        }
        rightButton.snp.makeConstraints {
            $0.trailing.equalToSuperview()
            $0.centerY.equalTo(containerView)
        }
        brandStackView.snp.makeConstraints {
            $0.top.equalTo(storeDetailLabel.snp.bottom).offset(10)
            $0.height.equalTo(24)
            $0.leading.trailing.equalTo(containerView)
            $0.bottom.equalTo(containerView)
        }
        
        //MARK: ViewAddTarget
        rightButton.addTarget(delegate, action: #selector(didTapRightButton), for: .touchUpInside)
        
        //MARK: Delegate
    }
    
    
    func setAttributedString(store: String, distance: String, address: String, isBookmark: Bool = false) {
        var storeDetailText = "#STORE \u{2022} #ADDRESS"
        storeDetailText = storeDetailText.replacingOccurrences(of: "#STORE", with: distance)
        storeDetailText = storeDetailText.replacingOccurrences(of: "#ADDRESS", with: address)
        //storeDetailText = storeDetailText.replacingOccurrences(of: "#PAY_FAIL", with: payFail)
        let attributedString = NSMutableAttributedString(string: storeDetailText)
        storeDetailLabel.attributedText = attributedString
        storeLabel.text = store
        if isBookmark { rightButton.tintColor = .pointBlue }
    }
    
    func addPayBrand(pays: [String]) {
        var paysImages: [UIImageView] = []
        pays.forEach {
            paysImages.append(BrandIconImageView(image: UIImage(systemName: $0)))
        }
        brandStackView.addArrangedSubviews(paysImages)
        brandStackView.addArrangedSubview(spacerView)
    }
    
    @objc func didTapRightButton() {
        delegate?.didTapStoreInfoButton(selectedIndex: thisIndex)
    }
}
