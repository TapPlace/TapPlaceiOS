//
//  SearchingTableViewCell.swift
//  TapPlace
//
//  Created by 이상준 on 2022/09/12.
//

import Foundation
import UIKit

// 검색 텍스트 필드를 입력중일 때 나올 셀
class SearchingTableViewCell: UITableViewCell {
    
    static let identifier = "SearchingCell"
    var searchModel: SearchModel?
    
    // 테이블 뷰 안 이미지 뷰
    private let img: UIImageView = {
        let imgView = UIImageView()
        imgView.image = .none
        return imgView
    }()
    
    // 테이블 뷰 안 라벨
    let placeNameLbl: UILabel = {
        let placeNameLbl = UILabel()
        placeNameLbl.text = ""
        placeNameLbl.textColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.7)
        placeNameLbl.font = .systemFont(ofSize: CommonUtils.resizeFontSize(size: 15))
        placeNameLbl.sizeToFit()
        return placeNameLbl
    }()
    
    // 테이블 뷰 셀 안 하단 선
    let bottomLine: UIView = {
        let bottomLine = UIView()
        bottomLine.backgroundColor = .init(hex: 0xDBDEE8, alpha: 0.4)
        return bottomLine
    }()
    
    private let distanceAddressLbl: UILabel = {
        let distanceAddressLbl = UILabel()
        distanceAddressLbl.text = ""
        distanceAddressLbl.textColor = .init(hex: 0x707070)
        distanceAddressLbl.font = .systemFont(ofSize: CommonUtils.resizeFontSize(size: 12))
        return distanceAddressLbl
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
        contentView.addSubview(img)
        contentView.addSubview(placeNameLbl)
        contentView.addSubview(distanceAddressLbl)
        contentView.addSubview(bottomLine)
    }
    
    private func setLayout() {
        img.snp.makeConstraints {
            $0.top.equalToSuperview().offset(19)
            $0.leading.equalToSuperview().offset(22)
            $0.width.height.equalTo(15)
        }
        
        placeNameLbl.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.leading.equalTo(img.snp.trailing).offset(10)
        }
        
        distanceAddressLbl.snp.makeConstraints {
            $0.top.equalTo(placeNameLbl.snp.bottom).offset(4)
            $0.leading.equalTo(img.snp.trailing).offset(10)
        }
        
        bottomLine.snp.makeConstraints {
            $0.leading.trailing.equalTo(contentView).inset(20)
            $0.bottom.equalTo(contentView)
            $0.height.equalTo(1)
        }
    }
    
    func prepare(categoryGroupCode: String?, placeName: String?, distance: String?, roadAddress: String? ,address: String?) {
        
        if let categoryGroupCode = categoryGroupCode {
            self.img.image = UIImage(named: "\(categoryGroupCode)")
            
            if self.img.image == .none {
                self.img.image = UIImage(named: "etc")
            }
        }
        
        // 도로명 주소가 없을 경우 지번 주소 사용
        let storeAddress: String? = roadAddress == "" ? address : roadAddress
        self.placeNameLbl.text = placeName
        self.distanceAddressLbl.text = "\(String(describing: distance!)) · \(String(describing: storeAddress!))"
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        placeNameLbl.textColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.7)
    }
}
