//
//  SearchingTableViewCell.swift
//  TapPlace
//
//  Created by 이상준 on 2022/08/15.
//

import UIKit

// 검색 테이블 뷰 셀
class SearchingTableViewCell: UITableViewCell {
    
    static let identifier = "SearchingRecordCell"
    
    // 테이블 뷰 안 이미지 뷰
    let img: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(named: "")
        return imgView
    }()
    
    // 테이블 뷰 안 라벨
    let label: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.7)
        label.font = .systemFont(ofSize: 15)
        label.sizeToFit()
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addContentView()
        autoLayout()
    }
    
    // content view에 추가
    private func addContentView() {
        contentView.addSubview(img)
        contentView.addSubview(label)
    }
    
    private func autoLayout() {
        img.snp.makeConstraints {
            $0.width.equalTo(20)
            $0.height.equalTo(20)
            $0.top.equalTo(contentView.safeAreaLayoutGuide).offset(16)
            $0.leading.equalTo(contentView.safeAreaLayoutGuide).offset(20)
            $0.bottom.equalTo(contentView.safeAreaLayoutGuide).offset(-18)
        }
        
        label.snp.makeConstraints {
            $0.top.equalTo(contentView.safeAreaLayoutGuide).offset(16)
            $0.leading.equalTo(img.snp_trailingMargin).offset(10)
            $0.bottom.equalTo(contentView.safeAreaLayoutGuide).offset(-18)
        }
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
