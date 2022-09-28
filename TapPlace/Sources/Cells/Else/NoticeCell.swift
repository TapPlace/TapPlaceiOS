//
//  NoticeCell.swift
//  TapPlace
//
//  Created by 이상준 on 2022/09/05.
//

import Foundation
import UIKit

class NoticeCell: UITableViewCell {
    
    static let identifier = "NoticeCell"
    
    let titleLbl: UILabel = {
        let titleLbl = UILabel()
        titleLbl.font = .systemFont(ofSize: 16)
        titleLbl.textColor = .init(hex: 0x4D4D4D)
        titleLbl.sizeToFit()
        return titleLbl
    }()
    
    let timeLbl: UILabel = {
       let timeLbl = UILabel()
        timeLbl.font = .systemFont(ofSize: 13)
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
        contentView.addSubview(timeLbl)
    }
    
    private func setLayout() {
        titleLbl.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.leading.equalToSuperview().offset(20)
        }
        
        timeLbl.snp.makeConstraints {
            $0.top.equalTo(titleLbl.snp.bottom).offset(6)
            $0.leading.equalToSuperview().offset(20)
        }
    }
    
    func prepare(title: String?, content: String?,writeDate: String?) {
        self.titleLbl.text = title
        self.timeLbl.text = writeDate
    }
}
