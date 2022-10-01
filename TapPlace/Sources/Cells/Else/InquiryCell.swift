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
    
    var acceptLbl: UILabel = {
        let acceptLbl = UILabel()
        acceptLbl.text = "접수완료"
        acceptLbl.font = .systemFont(ofSize: 12)
        acceptLbl.textColor = .init(hex: 0x9E9E9E)
        acceptLbl.layer.borderWidth = 1
        acceptLbl.layer.borderColor = .init(UIColor(hex: 0x9E9E9E).cgColor)
        acceptLbl.layer.cornerRadius = 10
        acceptLbl.textAlignment = .center
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
            $0.top.equalTo(titleLbl.snp.bottom).offset(10)
            $0.leading.equalToSuperview().offset(20)
            $0.width.equalTo(66)
            $0.height.equalTo(22)
        }
        
        timeLbl.snp.makeConstraints {
            $0.top.equalTo(titleLbl.snp.bottom).offset(12)
            $0.leading.equalTo(acceptLbl.snp.trailing).offset(8)
        }
    }
    
    func prepare(title: String?, writeDate: String?, content: String?, answerCheck: Int?) {
        self.titleLbl.text = title
        self.timeLbl.text = writeDate
        
        if answerCheck == 1 {
            self.acceptLbl.text = "답변완료"
            self.acceptLbl.textColor = .init(hex: 0x4E77FB)
            self.acceptLbl.layer.borderWidth = 1
            self.acceptLbl.layer.borderColor = UIColor.init(hex: 0x4E77FB).cgColor
            self.acceptLbl.backgroundColor = .white
            self.acceptLbl.layer.cornerRadius = 10
            self.acceptLbl.layer.masksToBounds = true
            self.acceptLbl.backgroundColor = .init(hex: 0xF4F7FF)
        } else {
            acceptLbl.text = "접수완료"
            acceptLbl.font = .systemFont(ofSize: 12)
            acceptLbl.textColor = .init(hex: 0x9E9E9E)
            acceptLbl.layer.borderWidth = 1
            acceptLbl.layer.borderColor = .init(UIColor(hex: 0x9E9E9E).cgColor)
            acceptLbl.layer.cornerRadius = 10
            acceptLbl.textAlignment = .center
            self.acceptLbl.backgroundColor = .white
        }
    }
}
