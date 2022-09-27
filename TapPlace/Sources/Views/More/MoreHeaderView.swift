//
//  MoreHeaderView.swift
//  TapPlace
//
//  Created by 박상현 on 2022/09/06.
//

import UIKit
import Combine

protocol MoreHeaderViewProtocol {
    func didTapPaymentsButton()
}

class MoreHeaderView: UIView {
    var storageViewModel = StorageViewModel()
    var userViewModel: UserViewModel? = nil {
        didSet {
            setBindings()
        }
        willSet {
            setBindings()
        }
    }
    
    var delegate: MoreHeaderViewProtocol?
    
    var subscription = Set<AnyCancellable>()
    
    let paymentsFrame: UIView = {
        let paymentsFrame = UIView()
        paymentsFrame.backgroundColor = .init(hex: 0xDBDEE8, alpha: 0.2)
        paymentsFrame.layer.cornerRadius = 6
        return paymentsFrame
    }()
    
    var payments: String = "" {
        willSet {
            paymentsLabel.text = newValue
        }
    }
    
    var paymentsLabel = UILabel()

    let paymentsButton = UIButton()
    let itemBookmark = MoreHeaderViewItem()
    let itemFeedback = MoreHeaderViewItem()
    let remainFeedback = MoreHeaderViewItem()
    
    var countOfBookmark: Int = 0 {
        willSet {
            itemBookmark.countOfItem = newValue
        }
    }
    
    var countOfFeedback: Int = 0 {
        willSet {
            itemFeedback.countOfItem = newValue
        }
    }
    
    var countOfRemainFeedback: Int = 0 {
        willSet {
            remainFeedback.countOfItem = newValue
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
extension MoreHeaderView {
    func setBindings() {
        self.userViewModel?.$userAllCount.sink { (result: UserAllCountModel) in
            self.countOfBookmark = Int(result.bookmarkCount) ?? 0
            self.countOfFeedback = Int(result.feedbackCount) ?? 0
            self.countOfRemainFeedback = result.remainCount
        }.store(in: &subscription)
    }
    
    func setupView() {
        let paymentTitleLabel: UILabel = {
            let paymentTitleLabel = UILabel()
            paymentTitleLabel.sizeToFit()
            paymentTitleLabel.text = "결제수단"
            paymentTitleLabel.font = .systemFont(ofSize: CommonUtils.resizeFontSize(size: 14), weight: .medium)
            return paymentTitleLabel
        }()
        let arrowImageView: UIImageView = {
            let arrowImageView = UIImageView()
            arrowImageView.contentMode = .scaleAspectFit
            arrowImageView.image = UIImage(systemName: "chevron.forward")
            arrowImageView.tintColor = .init(hex: 0x707070)
            return arrowImageView
        }()
        paymentsLabel = {
            let paymentsLabel = UILabel()
            paymentsLabel.text = "카카오페이, 네이버페이, 제로페이, 애플페이 비자, 컨택리스 마스터"
            paymentsLabel.font = .systemFont(ofSize: CommonUtils.resizeFontSize(size: 14), weight: .regular)
            paymentsLabel.textColor = .init(hex: 0x707070)
            paymentsLabel.numberOfLines = 1
            return paymentsLabel
        }()
        let itemStackView: UIStackView = {
            let itemStackView = UIStackView()
            itemStackView.axis = .horizontal
            itemStackView.distribution = .fillEqually
            itemStackView.spacing = 30
            return itemStackView
        }()
        let footerView: UIView = {
            let footerView = UIView()
            footerView.backgroundColor = .init(hex: 0xDBDEE8, alpha: 0.4)
            return footerView
        }()
        
        self.backgroundColor = .white
        itemBookmark.title = "즐겨찾기"
        itemFeedback.title = "피드백"
        remainFeedback.title = "남은 피드백"
        
        self.addSubview(paymentsFrame)
        paymentsFrame.addSubview(paymentTitleLabel)
        paymentsFrame.addSubview(arrowImageView)
        paymentsFrame.addSubview(paymentsLabel)
        paymentsFrame.addSubview(paymentsButton)
        self.addSubview(itemStackView)
        self.addSubview(footerView)
        itemStackView.addArrangedSubviews([itemBookmark, itemFeedback, remainFeedback])
        
        paymentsFrame.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(50)
        }
        paymentTitleLabel.snp.makeConstraints {
            $0.leading.equalTo(paymentsFrame).offset(20)
            $0.centerY.equalTo(paymentsFrame)
        }
        arrowImageView.snp.makeConstraints {
            $0.centerY.equalTo(paymentsFrame)
            $0.trailing.equalTo(paymentsFrame).offset(-20)
            $0.width.equalTo(20)
        }
        paymentsLabel.snp.makeConstraints {
            $0.leading.equalTo(paymentTitleLabel.snp.trailing).offset(20)
            $0.trailing.equalTo(arrowImageView.snp.leading).offset(-10)
            $0.centerY.equalTo(paymentsFrame)
        }
        paymentsButton.snp.makeConstraints {
            $0.edges.equalTo(paymentsFrame)
        }
        itemStackView.snp.makeConstraints {
            $0.top.equalTo(paymentsFrame.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(60)
        }
        footerView.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(6)
        }

        paymentsButton.addTarget(self, action: #selector(didTapPaymentsButton), for: .touchUpInside)
    }
    
    @objc func didTapPaymentsButton() {
        delegate?.didTapPaymentsButton()
    }
}
