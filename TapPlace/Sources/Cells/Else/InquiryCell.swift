//
//  InquiryCell.swift
//  TapPlace
//
//  Created by 이상준 on 2022/09/27.
//

import Foundation
import UIKit

class InquiryCell: UITableViewCell {
    static let identifier = "InquiryCell"
    
    let titleLbl: UILabel = {
        let titleLbl = UILabel()
        titleLbl.font = .systemFont(ofSize: 15)
        titleLbl.textColor = .init(hex: 0x4D4D4D)
        titleLbl.sizeToFit()
        return titleLbl
    }()
    
    let acceptLbl: UILabel = {
        let acceptLbl = UILabel()
        acceptLbl.text = "접수완료"
        acceptLbl.textColor = .init(hex: 0x9E9E9E)
        acceptLbl.layer.borderWidth = 1
        acceptLbl.layer.cornerRadius = 10
        return acceptLbl
    }()
    
    let timeLbl: UILabel = {
        let timeLbl = UILabel()
        timeLbl.font = .systemFont(ofSize: 14)
        timeLbl.textColor = .init(hex: 0x9E9E9E)
        timeLbl.sizeToFit()
        return timeLbl
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
        contentView.addSubview(titleLbl)
        contentView.addSubview(acceptLbl)
        contentView.addSubview(timeLbl)
    }
    
    private func setLayout() {
        titleLbl.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.leading.equalToSuperview().offset(20)
        }
        
        acceptLbl.snp.makeConstraints {
            $0.top.equalTo(titleLbl).offset(10)
            $0.leading.equalToSuperview().offset(20)
        }
        
        timeLbl.snp.makeConstraints {
            $0.top.equalTo(titleLbl).offset(10)
            $0.leading.equalTo(acceptLbl).offset(8)
        }
    }
    
    private func prepare() {
        
    }
}
