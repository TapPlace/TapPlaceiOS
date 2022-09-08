//
//  PaymentFeedbackCell.swift
//  TapPlace
//
//  Created by 이상준 on 2022/09/08.
//

import UIKit

class FeedbackDetailCell: UITableViewCell {
    
    static let identifier = "FeedbackDetailCell"
    
    private let imgView: UIImageView = {
        let imgView = UIImageView()
        return imgView
    }()
    
    private let payNameLbl: UILabel = {
        let payNameLbl = UILabel()
        payNameLbl.font = .systemFont(ofSize: 15)
        payNameLbl.textColor = .init(hex: 0x4D4D4D)
        payNameLbl.sizeToFit()
        return payNameLbl
    }()
    
    private let whetherToPayLbl: UILabel = {
        let whetherToPayLbl = UILabel()
        whetherToPayLbl.font = .systemFont(ofSize: 14)
        whetherToPayLbl.textColor = .init(hex: 0x707070)
        whetherToPayLbl.sizeToFit()
        return whetherToPayLbl
    }()
    
    private func addContentView() {
        contentView.addSubview(imgView)
        contentView.addSubview(payNameLbl)
        contentView.addSubview(whetherToPayLbl)
    }
    
    private func setLayout() {
        imgView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.leading.equalToSuperview().offset(20)
            $0.width.height.equalTo(32)
        }
        
        payNameLbl.snp.makeConstraints {
            $0.top.equalToSuperview().offset(22)
            $0.leading.equalTo(imgView.snp.trailing).offset(8)
            $0.height.equalTo(20)
        }
        
        whetherToPayLbl.snp.makeConstraints {
            $0.top.equalToSuperview().offset(23)
            $0.trailing.equalToSuperview().offset(-20)
            $0.height.equalTo(18)
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addContentView()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func prepare(img: UIImage?, payName: String?, whetherToPay: String?) {
        self.imgView.image = img
        self.payNameLbl.text = payName
        self.whetherToPayLbl.text = whetherToPay
        
        if whetherToPay == "결제성공" {
            DispatchQueue.main.async {
                self.whetherToPayLbl.textColor = .init(hex: 0x4E77FB)
            }
        }
    }
}
