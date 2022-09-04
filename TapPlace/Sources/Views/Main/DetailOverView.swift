//
//  DetailOverView.swift
//  TapPlace
//
//  Created by 박상현 on 2022/08/16.
//

import UIKit

class DetailOverView: UIView {

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
            $0.height.equalTo(120)
        }

        
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
