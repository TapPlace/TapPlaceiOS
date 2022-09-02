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
    
    let storeNameLabel: UILabel = {
        let storeNameLabel = UILabel()
        storeNameLabel.font = UIFont.boldSystemFont(ofSize: 18)
        storeNameLabel.sizeToFit()
        return storeNameLabel
    }()
    
    let storeKindLabel: UILabel = {
        let storeKindLabel = UILabel()
        storeKindLabel.font = UIFont.systemFont(ofSize: 13)
        storeKindLabel.textColor = UIColor(red: 0.62, green: 0.62, blue: 0.62, alpha: 1)
        return storeKindLabel
    }()
    
    let addressLbl: UILabel = {
        let addressLbl = UILabel()
        addressLbl.font = UIFont.systemFont(ofSize: 14)
        addressLbl.textColor = UIColor(red: 0.439, green: 0.439, blue: 0.439, alpha: 1)
        addressLbl.sizeToFit()
        return addressLbl
    }()
    
    let telLbl: UILabel = {
        let telLbl = UILabel()
        telLbl.font = UIFont.systemFont(ofSize: 14)
        telLbl.textColor = UIColor(red: 0.439, green: 0.439, blue: 0.439, alpha: 1)
        telLbl.sizeToFit()
        return telLbl
    }()
    
    let lineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = UIColor.systemGray5
        return lineView
    }()
    
    let bottomView: UIView = {
        let bottomView = UIView()
        bottomView.backgroundColor = .white
        return bottomView
    }()
    
    let editImg: UIImageView = {
        let editImg = UIImageView()
        editImg.image = UIImage(named: "")
        return editImg
    }()
    
    let editLbl: UILabel = {
        let editLbl = UILabel()
        editLbl.font = UIFont.systemFont(ofSize: 14)
        editLbl.textColor = UIColor(hex: 0x707070)
        editLbl.sizeToFit()
        editLbl.text = "정보 수정 요청"
        return editLbl
    }()
    
    let editBtn: UIButton = {
        let editBtn = UIButton()
        editBtn.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        editBtn.tintColor = UIColor.init(hex: 0x9E9E9E)
        return editBtn
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addContentView()
        setLayout()
        self.bottomView.isUserInteractionEnabled = true
        self.bottomView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.viewTapped)))

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.prepare(storeName: nil, storeKind: nil, address: nil, tel: nil)
    }
    
    private func addContentView(){
        contentView.addSubview(storeNameLabel)
        contentView.addSubview(storeKindLabel)
        contentView.addSubview(positionImg)
        contentView.addSubview(addressLbl)
        contentView.addSubview(telImg)
        contentView.addSubview(telLbl)
        contentView.addSubview(lineView)
        contentView.addSubview(bottomView)
        bottomView.addSubview(editImg)
        bottomView.addSubview(editLbl)
        bottomView.addSubview(editBtn)
    }
    
    private func setLayout() {
        storeNameLabel.snp.makeConstraints {
            $0.top.equalTo(contentView.safeAreaLayoutGuide).offset(24)
            $0.leading.equalTo(contentView.safeAreaLayoutGuide).offset(20)
        }
        
        storeKindLabel.snp.makeConstraints {
            $0.top.equalTo(contentView.safeAreaLayoutGuide).offset(29)
            $0.leading.equalTo(storeNameLabel.snp.trailing).offset(6)
        }
        
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
        
        lineView.snp.makeConstraints {
            $0.top.equalTo(telLbl.snp.bottom).offset(18)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.height.equalTo(1)
        }
        
        bottomView.snp.makeConstraints {
            $0.top.equalTo(lineView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        editImg.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.leading.equalToSuperview().offset(20)
            $0.height.width.equalTo(16)
        }
        
        editLbl.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.leading.equalTo(editImg.snp.trailing).offset(10)
        }
        
        editBtn.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
        }
    }
    
    // 셀에 데이터를 넣는 함수
    func prepare(storeName: String?, storeKind: String?, address: String?, tel: String?) {
        self.storeNameLabel.text = storeName
        self.storeKindLabel.text = storeKind
        self.positionImg.image = UIImage(named: "")
        self.telImg.image = UIImage(named: "")
        self.addressLbl.text = address
        self.telLbl.text = tel
    }
    
    @objc func viewTapped(_ sender: UITapGestureRecognizer) {
        print("\(sender.view!) 클릭됨")
    }
}
