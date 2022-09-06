//
//  StoreInfoView.swift
//  TapPlace
//
//  Created by 박상현 on 2022/09/04.
//

import UIKit
import CoreLocation

protocol StoreInfoViewButtonProtocol {
    func didTapStoreInfoButton(selectedIndex: Int?)
}


class StoreInfoView: UIView {
    var delegate: StoreInfoViewButtonProtocol?
    
    var storeInfo: StoreInfo? = nil {
        willSet {
            guard let store = newValue else { return }
            storeLabel.text = newValue?.placeName
            
            storeGroupLabel.text = store.categoryGroupName == "" ? "기타" : store.categoryGroupName

            var placeDistance: Double?
            if let _ = UserInfo.userLocation {
                let storeLocation = CLLocationCoordinate2D(latitude: Double(store.y) ?? 0, longitude: Double(store.x) ?? 0)
                placeDistance = UserInfo.userLocation?.distance(from: storeLocation)
            } else {
                placeDistance = 0
            }
            
            let storeAddress: String = store.roadAddressName == "" ? store.addressName : store.roadAddressName
            
            self.setAttributedString(store: store.placeName, distance: DistancelModel.getDistance(distance: placeDistance! / 1000), address: storeAddress)
            
            if let payments = newValue?.feedback {
                var paymentPay: [String] = []
                for payment in payments {
                    paymentPay.append(payment.pay)
                }
                addPayBrand(pays: paymentPay)
            }

        }
    }
    
    var payLists: [String] = [] {
        willSet {
            //addPayBrand(pays: newValue)
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
    
    var buttonIcon: UIImage? = nil {
        willSet {
            guard let buttonIcon = newValue else { return }
            rightButton.setImage(buttonIcon, for: .normal)
        }
    }
    
    enum TitleSize {
        case small, medium, large
    }
    
    var titleSize: TitleSize = .medium {
        willSet {
            switch newValue {
            case .small:
                storeLabel.font = .systemFont(ofSize: CommonUtils.resizeFontSize(size: 14), weight: .semibold)
            case .medium:
                storeLabel.font = .systemFont(ofSize: CommonUtils.resizeFontSize(size: 16), weight: .semibold)
            case .large:
                storeLabel.font = .systemFont(ofSize: CommonUtils.resizeFontSize(size: 18), weight: .semibold)
            }
        }
    }
    
    var thisIndex: Int? 
    
    let containerView: UIView = {
        let containerView = UIView()
        return containerView
    }()
    let storeLabel: VerticalAlignLabel = {
        let storeLabel = VerticalAlignLabel()
        storeLabel.sizeToFit()
        storeLabel.verticalAlignment = .bottom
        storeLabel.text = "가맹점 이름"
        storeLabel.textColor = .black
        storeLabel.font = .systemFont(ofSize: CommonUtils.resizeFontSize(size: 16), weight: .regular)
        return storeLabel
    }()
    let storeGroupLabel: VerticalAlignLabel = {
        let storeGroupLabel = VerticalAlignLabel()
        storeGroupLabel.sizeToFit()
        storeGroupLabel.verticalAlignment = .bottom
        storeGroupLabel.text = ""
        storeGroupLabel.textColor = .init(hex: 0x9e9e9e)
        storeGroupLabel.font = .systemFont(ofSize: CommonUtils.resizeFontSize(size: 14), weight: .regular)
        return storeGroupLabel
    }()
    let storeDetailLabel: UILabel = {
        let storeDetailLabel = UILabel()
        storeDetailLabel.font = .systemFont(ofSize: CommonUtils.resizeFontSize(size: 12), weight: .regular)
        storeDetailLabel.textColor = UIColor.init(hex: 0x9a9fb0)
        return storeDetailLabel
    }()
    let rightButton: UIButton = {
        let rightButton = UIButton()

        rightButton.tintColor = UIColor.init(hex: 0xdbdee8)
        rightButton.isHidden = true
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
        containerView.addSubview(storeGroupLabel)
        containerView.addSubview(storeDetailLabel)
        containerView.addSubview(rightButton)
        containerView.addSubview(brandStackView)
        
        //MARK: ViewContraints
        containerView.snp.makeConstraints {
            $0.leading.centerY.trailing.equalToSuperview()
            $0.top.bottom.equalToSuperview().inset(15)
        }
        storeLabel.snp.makeConstraints {
            $0.leading.equalTo(containerView)
            $0.top.equalTo(containerView)
        }
        storeGroupLabel.snp.makeConstraints {
            $0.leading.equalTo(storeLabel.snp.trailing).offset(10)
            $0.bottom.equalTo(storeLabel)
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
//            $0.top.equalTo(storeDetailLabel.snp.bottom).offset(10)
            $0.height.equalTo(28)
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
            if let payment = PaymentModel.thisPayment(payment: $0) {
                let payIcon = payment.payments == "" ? payment.brand : payment.payments
                paysImages.append(BrandIconImageView(image: UIImage(named: payIcon)))
            }
        }
        brandStackView.addArrangedSubviews(paysImages)
        brandStackView.addArrangedSubview(spacerView)
    }
    
    @objc func didTapRightButton() {
        delegate?.didTapStoreInfoButton(selectedIndex: thisIndex)
    }
}
