//
//  AlarmCell.swift
//  TapPlace
//
//  Created by 이상준 on 2022/09/05.
//

import Foundation
import UIKit

class AlarmCell: UITableViewCell {
    
    static let identifier = "AlarmCell"
    
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
    
    let pushBtn: UIButton = {
        let pushBtn = UIButton()
        pushBtn.setImage(UIImage(systemName: "chevron.forward"), for: .normal)
        pushBtn.tintColor = .init(hex: 0x9E9E9E)
        return pushBtn
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
        contentView.addSubview(subTitleLbl)
        contentView.addSubview(titleLbl)
        contentView.addSubview(timeLbl)
        contentView.addSubview(pushBtn)
    }
    
    private func setLayout() {
        subTitleLbl.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.leading.equalToSuperview().offset(20)
        }
        
        titleLbl.snp.makeConstraints {
            $0.top.equalTo(subTitleLbl.snp.bottom).offset(6)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalTo(pushBtn).offset(-30)
        }
        
        timeLbl.snp.makeConstraints {
            $0.top.equalTo(titleLbl.snp.bottom).offset(6)
            $0.leading.equalToSuperview().offset(20)
        }
        
        pushBtn.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-26)
            $0.height.width.equalTo(15)
        }
    }
    
    func prepare(subTitle: String?, title: String?, date: String?) {
        self.subTitleLbl.text = subTitle
        self.titleLbl.text = title
        self.timeLbl.text = date
    }
}
