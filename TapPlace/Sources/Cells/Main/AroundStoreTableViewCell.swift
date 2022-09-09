//
//  AroundStoreTableViewCell.swift
//  TapPlace
//
//  Created by 박상현 on 2022/08/17.
//

import UIKit
 
class AroundStoreTableViewCell: UITableViewCell {

    static let cellId = "aroundStoreItem"
    
    var cellIndex: Int = 0 {
        willSet {
            storeInfoView.thisIndex = newValue
        }
    }
    
    var storeInfo: AroundStores = AroundStores(num: 0, storeID: "", placeName: "", addressName: "", roadAddressName: "", categoryGroupName: "", phone: "", x: "", y: "", distance: 0, pays: []) {
        willSet {
            storeInfoView.storeInfo = newValue
        }
    }

    let storeInfoView = StoreInfoView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super .init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        /// 재사용하면서 생기는 문제로 인해 셀 초기화
        storeInfoView.brandStackView.removeAllArrangedSubviews()
        storeInfoView.rightButton.tintColor = UIColor.init(hex: 0xdbdee8)
    }
}

extension AroundStoreTableViewCell {
    func setupCell() {
        addSubview(storeInfoView)
        
        storeInfoView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func sendStoreData(store: StoreInfo) {
        
    }
}
