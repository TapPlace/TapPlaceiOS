//
//  SearchingActionTableViewCell.swift
//  TapPlace
//
//  Created by 이상준 on 2022/08/18.
//

import UIKit

class SearchActionTabelViewCell: UITableViewCell {
    
    static let identifier = "SearchActionCell"
    
    // 테이블 뷰 안 이미지 뷰
    let img: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(named: "")
        return imgView
    }()
    
    // 테이블 뷰 안 위 라벨
    let topLabel: UILabel = {
        let topLabel = UILabel()
        topLabel.text = ""
        topLabel.textColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.7)
        topLabel.font = .systemFont(ofSize: 15)
        topLabel.sizeToFit()
        return topLabel
    }()
    
    // 테이블 뷰 안 아래 라벨
    let bottomLabel: UILabel = {
        let bottomLabel = UILabel()
        bottomLabel.text = ""
        bottomLabel.textColor = UIColor.init(red: 168, green: 172, blue: 187, alpha: 1)
        bottomLabel.font = .systemFont(ofSize: 12)
        bottomLabel.sizeToFit()
        return bottomLabel
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addContentView()
        autoLayout()
    }
    
    // content view에 추가
    private func addContentView() {
        contentView.addSubview(img)
        contentView.addSubview(topLabel)
        contentView.addSubview(bottomLabel)
    }
    
    private func autoLayout() {
        img.snp.makeConstraints {
            $0.width.equalTo(20)
            $0.height.equalTo(20)
            $0.top.equalTo(contentView.safeAreaLayoutGuide).offset(20)
            $0.leading.equalTo(contentView.safeAreaLayoutGuide).offset(22)
            $0.bottom.equalTo(contentView.safeAreaLayoutGuide).offset(37)
        }
        
        topLabel.snp.makeConstraints {
            $0.top.equalTo(contentView.safeAreaLayoutGuide).offset(16)
            $0.leading.equalTo(img.snp_trailingMargin).offset(10)
            $0.bottom.equalTo(bottomLabel.snp.top).offset(-4)
        }
        
        bottomLabel.snp.makeConstraints {
            $0.top.equalTo(topLabel.snp.bottom).offset(4)
            $0.leading.equalTo(contentView.safeAreaLayoutGuide).offset(32)
            $0.bottom.equalTo(contentView.safeAreaLayoutGuide).offset(16)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
