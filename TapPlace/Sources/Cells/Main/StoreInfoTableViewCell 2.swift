//
//  StoreDetailTableViewCell.swift
//  TapPlace
//
//  Created by 이상준 on 2022/08/29.
//

import Foundation
import UIKit

class StoreInfoTableViewCell: UITableViewCell {
    
    static let identifier = "StoreInfoTableViewCell"
    
    let positionImg: UIImageView = {
        let positionImg = UIImageView()
        return positionImg
    }()
    
    let telImg: UIImageView = {
        let telImg = UIImageView()
        return telImg
    }()
    
    let addressLbl: UILabel = {
       let addressLbl = UILabel()
        addressLbl.font = UIFont(name: "AppleSDGothicNeoM00-Regular", size: 14)
        addressLbl.textColor = UIColor(red: 0.439, green: 0.439, blue: 0.439, alpha: 1)
        addressLbl.sizeToFit()
        return addressLbl
    }()
    
    let telLbl: UILabel = {
       let telLbl = UILabel()
        telLbl.font = UIFont(name: "AppleSDGothicNeoM00-Regular", size: 14)
        telLbl.textColor = UIColor(red: 0.439, green: 0.439, blue: 0.439, alpha: 1)
        telLbl.sizeToFit()
        return telLbl
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addContentView()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
       super.prepareForReuse()
       self.prepare(storeName: nil, storeKind: nil, address: nil, tel: nil)
     }
    
    private func addContentView(){
        contentView.addSubview(positionImg)
        contentView.addSubview(addressLbl)
        contentView.addSubview(telImg)
        contentView.addSubview(telLbl)
    }
    
    private func setLayout() {
        positionImg.snp.makeConstraints {
            $0.top.equalTo(contentView.safeAreaLayoutGuide).offset(65)
            $0.leading.equalTo(contentView.safeAreaLayoutGuide).offset(22)
            $0.height.width.equalTo(16)
        }
        
        addressLbl.snp.makeConstraints {
            $0.top.equalTo(contentView.safeAreaLayoutGuide).offset(65)
            $0.leading.equalTo(positionImg.snp.trailing).offset(10)
        }
        
        telImg.snp.makeConstraints {
            $0.top.equalTo(positionImg.snp.bottom).offset(12)
            $0.leading.equalTo(contentView.safeAreaLayoutGuide).offset(22)
            $0.height.width.equalTo(16)
        }
        
        telLbl.snp.makeConstraints {
            $0.top.equalTo(addressLbl.snp.bottom).offset(10)
            $0.leading.equalTo(telImg.snp.trailing).offset(10)
        }
    }
    
    func prepare(storeName: String?, storeKind: String?, address: String?, tel: String?) {
        self.positionImg.image = UIImage(named: "")
        self.telImg.image = UIImage(named: "")
        self.addressLbl.text = address
        self.telLbl.text = tel
    }
}
