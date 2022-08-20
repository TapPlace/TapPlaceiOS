//
//  AroundStoreTableViewCell.swift
//  TapPlace
//
//  Created by 박상현 on 2022/08/17.
//

import UIKit

class AroundStoreTableViewCell: UITableViewCell {

    static let cellId = "aroundStoreItem"
    
    var payLists: [String] = [] {
        willSet {
            payLists = newValue
            addPayBrand(pays: newValue)
        }
    }
    
    func setAttributedString(store: String, distance: String, address: String, isBookmark: Bool = false) {
        var storeDetailText = "#STORE \u{2022} #ADDRESS"
        storeDetailText = storeDetailText.replacingOccurrences(of: "#STORE", with: distance)
        storeDetailText = storeDetailText.replacingOccurrences(of: "#ADDRESS", with: address)
        //storeDetailText = storeDetailText.replacingOccurrences(of: "#PAY_FAIL", with: payFail)
        let attributedString = NSMutableAttributedString(string: storeDetailText)
        //attributedString.addAttribute(.foregroundColor, value: UIColor.pointBlue, range: (storeDetailText as NSString).range(of: paySuccess + "%"))
        storeDetailLabel.attributedText = attributedString
        storeLabel.text = store
        if isBookmark { bookmarkButton.tintColor = .pointBlue }
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
    let bookmarkButton: UIButton = {
        let bookmarkButton = UIButton()
        bookmarkButton.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
        bookmarkButton.tintColor = UIColor.init(hex: 0xdbdee8)
        return bookmarkButton
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
        containerView.addSubview(storeLabel)
        containerView.addSubview(storeDetailLabel)
        containerView.addSubview(bookmarkButton)
        containerView.addSubview(brandStackView)
        
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
        bookmarkButton.snp.makeConstraints {
            $0.trailing.equalToSuperview()
            $0.centerY.equalTo(containerView)
        }
        brandStackView.snp.makeConstraints {
            $0.top.equalTo(storeDetailLabel.snp.bottom).offset(10)
            $0.height.equalTo(24)
            $0.leading.trailing.equalTo(containerView)
            $0.bottom.equalTo(containerView)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        /// 재사용하면서 생기는 문제로 인해 셀 초기화
        brandStackView.removeAllArrangedSubviews()
    }
}
