//
//  StorePaymentTableViewCell.swift
//  TapPlace
//
//  Created by 이상준 on 2022/08/29.
//

import Foundation
import UIKit

class StorePaymentTableViewCell: UITableViewCell {
    
    static let identifier = "StorePaymentTableViewCell"
    
    var feedback: Feedback = Feedback.emptyFeedback {
        willSet {
            if let thisPay = PaymentModel.thisPayment(payment: newValue.pay) {
                paymentImg.image = thisPay.payments == "" ? UIImage.init(named: thisPay.brand) : UIImage.init(named: thisPay.payments)
                paymentLbl.text = thisPay.designation
                if let payResult = newValue.lastState {
                    if payResult == "success" {
                        self.whetherToPayLbl.text = "최근결제: 성공"
                        self.whetherToPayLbl.textColor = .pointBlue
                        self.whetherToPayLbl.font = .systemFont(ofSize: CommonUtils.resizeFontSize(size: 14), weight: .semibold)
                    } else {
                        self.whetherToPayLbl.text = "최근결제: 실패"
                        self.whetherToPayLbl.textColor = .init(hex: 0x707070)
                        self.whetherToPayLbl.font = .systemFont(ofSize: CommonUtils.resizeFontSize(size: 14), weight: .medium)
                    }
                    if let lastDate = newValue.lastTime {
                        successDateLbl.text = "\(lastDate.split(separator: " ")[0])"
                    }
                    let successCount = Double(newValue.success ?? 0)
                    let failCount = Double(newValue.fail ?? 0)
                    let totalCount = successCount + failCount
                    let successRate: Double = (successCount / totalCount) * 100
                    successRateLbl.text = "성공 \(Int(successRate))%"
                    successRateProgressView.progress = Float(Double(successRate) / 100)
                } else {
                    self.whetherToPayLbl.text = "최근결제: 없음"
                    self.whetherToPayLbl.textColor = .init(hex: 0x707070)
                    self.whetherToPayLbl.font = .systemFont(ofSize: CommonUtils.resizeFontSize(size: 14), weight: .medium)
                    successRateLbl.text = "성공 사례 없음"
                    successRateProgressView.progress = 0
                }


            }
        }
    }
    
    let paymentImg: UIImageView = {
        let paymentImg = UIImageView()
        return paymentImg
    }()
    
    let paymentLbl: UILabel = {
        let paymentLbl = UILabel()
        paymentLbl.font = UIFont.systemFont(ofSize: 15)
        paymentLbl.sizeToFit()
        return paymentLbl
    }()
    
    let whetherToPayLbl: UILabel = {
        let whetherToPayLbl = UILabel()
        whetherToPayLbl.textColor = UIColor(red: 0.439, green: 0.439, blue: 0.439, alpha: 1)
        whetherToPayLbl.font = UIFont.systemFont(ofSize: 14)
        whetherToPayLbl.sizeToFit()
        return whetherToPayLbl
    }()
    
    let successDateLbl: UILabel = {
        let successDateLbl = UILabel()
        successDateLbl.textColor = UIColor(hex: 0x9E9E9E)
        successDateLbl.font = UIFont.systemFont(ofSize: 12)
        successDateLbl.sizeToFit()
        return successDateLbl
    }()
    
    let successRateProgressView: UIProgressView = {
        let successRateProgressView = UIProgressView()
        successRateProgressView.progressViewStyle = .default
        successRateProgressView.backgroundColor = .init(hex: 0xE6E6E6)
        successRateProgressView.progressTintColor = .pointBlue
        successRateProgressView.progress = 0.1
        successRateProgressView.layer.cornerRadius = 6
        successRateProgressView.clipsToBounds = true
        return successRateProgressView
    }()
    
    let successRateLbl: UILabel = {
        let successRateLbl = UILabel()
        successRateLbl.textColor = UIColor(hex: 0x9E9E9E)
        successRateLbl.font = UIFont.systemFont(ofSize: 12)
        successRateLbl.sizeToFit()
        return successRateLbl
    }()
    
    let failRateLbl: UILabel = {
        let failRateLbl = UILabel()
        failRateLbl.textColor = UIColor(hex: 0x9E9E9E)
        failRateLbl.font = UIFont.systemFont(ofSize: 12)
        failRateLbl.sizeToFit()
        return failRateLbl
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addContentView()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addContentView() {
        contentView.addSubview(paymentImg)
        contentView.addSubview(paymentLbl)
        contentView.addSubview(whetherToPayLbl)
        contentView.addSubview(successDateLbl)
        contentView.addSubview(successRateProgressView)
        contentView.addSubview(successRateLbl)
        contentView.addSubview(failRateLbl)
    }
    
    private func setLayout() {
        paymentImg.snp.makeConstraints {
            $0.top.equalTo(contentView.safeAreaLayoutGuide).offset(16)
            $0.leading.equalTo(contentView.safeAreaLayoutGuide).offset(20)
            $0.height.width.equalTo(32)
        }
        
        paymentLbl.snp.makeConstraints {
            $0.top.equalTo(contentView.safeAreaLayoutGuide).offset(22)
            $0.leading.equalTo(paymentImg.snp.trailing).offset(8)
        }
        
        whetherToPayLbl.snp.makeConstraints {
            $0.top.equalTo(paymentImg.snp.bottom).offset(16)
            $0.leading.equalTo(contentView.safeAreaLayoutGuide).offset(20)
        }
        
        successDateLbl.snp.makeConstraints {
            $0.top.equalTo(paymentImg.snp.bottom).offset(18)
            $0.leading.equalTo(whetherToPayLbl.snp.trailing).offset(6)
        }
        
        successRateProgressView.snp.makeConstraints {
            $0.top.equalTo(whetherToPayLbl.snp.bottom).offset(8)
            $0.leading.equalTo(contentView.safeAreaLayoutGuide).offset(20)
            $0.trailing.equalTo(contentView.safeAreaLayoutGuide).offset(-20)
            $0.height.equalTo(12)
        }
        
        successRateLbl.snp.makeConstraints {
            $0.top.equalTo(successRateProgressView.snp.bottom).offset(4)
            $0.leading.equalTo(contentView.safeAreaLayoutGuide).offset(20)
        }
        
        failRateLbl.snp.makeConstraints {
            $0.top.equalTo(successRateProgressView.snp.bottom).offset(4)
            $0.trailing.equalTo(contentView.safeAreaLayoutGuide).offset(-20)
        }
    }
    
    func prepare(pay: String?, payName: String?, success: Bool?, successDate: String?, successRate: Int?) {
        self.paymentImg.image = UIImage(named: "")
        self.paymentLbl.text = payName
        if success == true {
            self.whetherToPayLbl.text = "최근결제: 성공"
            self.whetherToPayLbl.textColor = .pointBlue
        }else {
            self.whetherToPayLbl.text = "최근결제: 실패"
        }
        self.successDateLbl.text = successDate
        self.successRateProgressView.progress = Float(successRate!)
        self.successRateLbl.text = "성공 \(successRate!)%"
        self.failRateLbl.text = "실패 \(100 - successRate!)%"
    }
}
