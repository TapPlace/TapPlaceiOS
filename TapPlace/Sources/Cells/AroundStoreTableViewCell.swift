//
//  AroundStoreTableViewCell.swift
//  TapPlace
//
//  Created by 박상현 on 2022/08/17.
//

import UIKit

class AroundStoreTableViewCell: UITableViewCell {

    static let cellId = "aroundStoreItem"
    
    var distance: String = "알 수 없음"  {
        willSet {
            distance = newValue
        }
    }
    var paySuccess: String = "알 수 없음"  {
        willSet {
            paySuccess = newValue
        }
    }
    var payFail: String = "알 수 없음"  {
        willSet {
            payFail = newValue
        }
    }
    var payLists: [String] = [] {
        willSet {
            payLists = newValue
            addPayBrand(pays: newValue)
        }
    }
    
    func setAttributedString(distance: String, paySuccess: String, payFail: String) {
        var storeDetailText = "#STORE \u{2022} 결제성공 #PAY_SUCCESS% \u{2022} 결제실패 #PAY_FAIL%"
        storeDetailText = storeDetailText.replacingOccurrences(of: "#STORE", with: distance)
        storeDetailText = storeDetailText.replacingOccurrences(of: "#PAY_SUCCESS", with: paySuccess)
        storeDetailText = storeDetailText.replacingOccurrences(of: "#PAY_FAIL", with: payFail)
        let attributedString = NSMutableAttributedString(string: storeDetailText)
        attributedString.addAttribute(.foregroundColor, value: UIColor.pointBlue, range: (storeDetailText as NSString).range(of: paySuccess + "%"))
        storeDetailLabel.attributedText = attributedString
    }
    func addPayBrand(pays: [String]) {
        var paysImages: [UIImageView] = []
        pays.forEach {
            paysImages.append(BrandIconImageView(image: UIImage(systemName: $0)))
        }
        brandStackView.addArrangedSubviews(paysImages)
        brandStackView.addArrangedSubview(spacerView)
    }

    let containerView: UIView = {
        let containerView = UIView()
        return containerView
    }()
    let brandImage: UIImageView = {
        let brandImage = UIImageView()
        brandImage.backgroundColor = UIColor.init(hex: 0xdbdee8, alpha: 0.3)
        brandImage.layer.cornerRadius = 8
        brandImage.clipsToBounds = true
        return brandImage
    }()
    let storeLabel: UILabel = {
        let storeLabel = UILabel()
        storeLabel.sizeToFit()
        storeLabel.text = "세븐일레븐 염창점"
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
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super .init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupCell() {
        addSubview(containerView)
        containerView.addSubview(brandImage)
        containerView.addSubview(storeLabel)
        containerView.addSubview(storeDetailLabel)
        containerView.addSubview(brandStackView)
        
        
        containerView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(brandStackView)
        }
        brandImage.snp.makeConstraints {
            $0.width.height.equalTo(68)
            $0.top.leading.equalTo(containerView)
        }
        storeLabel.snp.makeConstraints {
            $0.leading.equalTo(brandImage.snp.trailing).offset(16)
            $0.top.equalTo(brandImage)
        }
        storeDetailLabel.snp.makeConstraints {
            $0.leading.equalTo(storeLabel)
            $0.top.equalTo(storeLabel.snp.bottom).offset(4)
        }
        brandStackView.snp.makeConstraints {
            $0.top.equalTo(storeDetailLabel.snp.bottom).offset(12)
            $0.leading.equalTo(storeDetailLabel)
            $0.height.equalTo(24)
            $0.trailing.equalTo(containerView)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        /// 재사용하면서 생기는 문제로 인해 셀 초기화
        brandStackView.removeAllArrangedSubviews()
    }
}
