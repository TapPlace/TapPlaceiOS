//
//  DetailOverView.swift
//  TapPlace
//
//  Created by 박상현 on 2022/08/16.
//

import UIKit

class DetailOverView: UIView, CustomToolBarProtocol {
    var storeInfo: StoreInfo = StoreInfo(num: 1, storeID: "118519786", placeName: "플랜에이스터디카페 서초교대센터", addressName: "서울 서초구 서초동 1691-2", roadAddressName: "서울 서초구 서초중앙로24길 20", categoryGroupName: "", phone: "02-3143-0909", x: "127.015695735359", y: "37.4947251545286", feedback: nil)
    

    
    let toolBar = CustomToolBar()
    let storeInfoView = StoreInfoView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        
        let containerView: UIView = {
            let containerView = UIView()
            return containerView
        }()
        
        
        addSubview(toolBar)
        addSubview(containerView)
        containerView.addSubview(storeInfoView)
        

        toolBar.snp.makeConstraints {
            $0.leading.trailing.bottom.equalTo(safeAreaLayoutGuide)
            $0.height.equalTo(toolBar.toolBar)
        }
        containerView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.bottom.equalTo(toolBar.snp.top).offset(-16)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        storeInfoView.snp.makeConstraints {
            $0.leading.trailing.equalTo(containerView)
            $0.bottom.equalTo(toolBar.snp.top)
            $0.height.equalTo(110)
        }

        toolBar.delegate = self
        
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
