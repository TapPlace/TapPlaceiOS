//
//  AlarmCell.swift
//  TapPlace
//
//  Created by 이상준 on 2022/09/05.
//

import Foundation
import UIKit

class AlarmCell: UITableViewCell {
    
    let subTitleLbl: UILabel = {
        let subTitleLbl = UILabel()
        subTitleLbl.font = .systemFont(ofSize: 13)
        subTitleLbl.textColor = .init(hex: 0x707070)
        subTitleLbl.sizeToFit()
        return subTitleLbl
    }()
    
    let titleLbl: UILabel = {
        let titleLbl = UILabel()
        titleLbl.font = .systemFont(ofSize: 15)
        titleLbl.numberOfLines = 2
        titleLbl.sizeToFit()
        return titleLbl
    }()
    
    let timeLbl: UILabel = {
        let timeLbl = UILabel()
        timeLbl.font = .systemFont(ofSize: 12)
        timeLbl.textColor = .init(hex: 0x9E9E9E)
        timeLbl.sizeToFit()
        return timeLbl
    }()
    
//    let pushBtn: UIButton = {
//        let pushBtn = UIButton()
//        pushBtn.setImage("chevron.right", for: .normal)
//        pushBtn.
//    }
//
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addContentView()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addContentView() {
        contentView.addSubview(subTitleLbl)
        contentView.addSubview(titleLbl)
        contentView.addSubview(timeLbl)
    }
    
    private func setLayout() {
        subTitleLbl.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.leading.equalToSuperview().offset(20)
        }
        
        titleLbl.snp.makeConstraints {
            $0.top.equalTo(subTitleLbl.snp.bottom).offset(6)
            $0.leading.equalToSuperview().offset(20)
        }
        
        timeLbl.snp.makeConstraints {
            $0.top.equalTo(titleLbl).offset(6)
            $0.leading.equalToSuperview().offset(20)
        }
    }
    
}
