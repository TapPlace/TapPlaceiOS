//
//  FeedbackRequestTableViewCell.swift
//  TapPlace
//
//  Created by 박상현 on 2022/09/07.
//

import UIKit

protocol FeedbackRequestCellProtocol {
    func didTapFeedbackButton(indexPath: IndexPath, payment: String, type: FeedbackButton.FeedbackButtonStyle)
}

class FeedbackRequestTableViewCell: UITableViewCell {

    static let cellId = "feedbackRequestItem"
    
    var delegate: FeedbackRequestCellProtocol?
    var cellIndex: Int = 0
    var cellIndexPath: IndexPath = IndexPath(row: 0, section: 0)
    var paymentIcon = UIImageView()
    var paymentLabel = UILabel()
    let feedbackSuccessButton = FeedbackButton()
    let feedbackFailButton = FeedbackButton()
    
    var feedbackModel: FeedbackRequestModel? = nil {
        willSet {
            guard let payment = newValue?.payment else { return }
            paymentIcon.image = UIImage(named: payment.payments == "" ? payment.brand : payment.payments )
            paymentLabel.text = payment.designation
        }
    }
    
    var setButtonStyle: FeedbackButton.FeedbackButtonStyle = .base {
        willSet {
            switch newValue {
            case .success:
                feedbackSuccessButton.setButtonStyle = .success
                feedbackFailButton.setButtonStyle = .base
            case .fail:
                feedbackSuccessButton.setButtonStyle = .base
                feedbackFailButton.setButtonStyle = .fail
            default:
                feedbackSuccessButton.setButtonStyle = .base
                feedbackFailButton.setButtonStyle = .base
            }
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super .init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension FeedbackRequestTableViewCell {
    func setupCell() {
        let containerView = UIView()
        
        paymentIcon = {
            let paymentIconImageView = UIImageView()
            return paymentIconImageView
        }()
        paymentLabel = {
            let paymentLabel = UILabel()
            paymentLabel.textColor = .black
            paymentLabel.font = .systemFont(ofSize: CommonUtils.resizeFontSize(size: 15), weight: .regular)
            return paymentLabel
        }()
        
        feedbackSuccessButton.title = "결제성공"
        feedbackFailButton.title = "결제실패"
        feedbackSuccessButton.button.addTarget(self, action: #selector(didTapFeedbackButton(_:)), for: .touchUpInside)
        feedbackFailButton.button.addTarget(self, action: #selector(didTapFeedbackButton(_:)), for: .touchUpInside)

        
        self.addSubview(containerView)
        containerView.addSubview(paymentIcon)
        containerView.addSubview(paymentLabel)
        containerView.addSubview(feedbackSuccessButton)
        containerView.addSubview(feedbackFailButton)
        
        containerView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        paymentIcon.snp.makeConstraints {
            $0.leading.equalTo(containerView)
            $0.width.height.equalTo(32)
            $0.centerY.equalTo(containerView)
        }
        paymentLabel.snp.makeConstraints {
            $0.leading.equalTo(paymentIcon.snp.trailing).offset(10)
            $0.centerY.equalTo(containerView)
        }
        feedbackFailButton.snp.makeConstraints {
            $0.trailing.equalTo(containerView)
            $0.height.equalTo(paymentIcon)
            $0.centerY.equalTo(containerView)
        }
        feedbackSuccessButton.snp.makeConstraints {
            $0.trailing.equalTo(feedbackFailButton.snp.leading).offset(-5)
            $0.height.equalTo(paymentIcon)
            $0.centerY.equalTo(containerView)
        }
        
        
        self.selectionStyle = .none
    }
    
    @objc func didTapFeedbackButton(_ sender: UIButton) {
        var paymentString: String = ""
        if let payment = feedbackModel?.payment {
            paymentString = PaymentModel.encodingPayment(payment: payment)
        }
        switch sender {
        case feedbackSuccessButton.button:
            delegate?.didTapFeedbackButton(indexPath: cellIndexPath, payment: paymentString, type: .success)
        case feedbackFailButton.button:
            delegate?.didTapFeedbackButton(indexPath: cellIndexPath, payment: paymentString, type: .fail)
        default: break
        }
    }
}
