//
//  DetailOverView.swift
//  TapPlace
//
//  Created by 박상현 on 2022/08/16.
//

import UIKit

class DetailOverView: UIView {

    let toolBar = CustomToolBar()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        
        let containerView: UIView = {
            let containerView = UIView()
            return containerView
        }()
        let storeNameLabel: UILabel = {
            let storeNameLabel = UILabel()
            storeNameLabel.sizeToFit()
            storeNameLabel.text = "스타벅스 양천향교역점"
            storeNameLabel.textColor = .black.withAlphaComponent(0.7)
            storeNameLabel.font = .systemFont(ofSize: CommonUtils.resizeFontSize(size: 20), weight: .semibold)
            return storeNameLabel
        }()
        let storeCategoryLabel: VerticalAlignLabel = {
            let storeCategoryLabel = VerticalAlignLabel()
            storeCategoryLabel.verticalAlignment = .bottom
            storeCategoryLabel.text = "카페/디저트"
            storeCategoryLabel.textColor = .black.withAlphaComponent(0.3)
            storeCategoryLabel.font = .systemFont(ofSize: CommonUtils.resizeFontSize(size: 14), weight: .regular)
            return storeCategoryLabel
        }()
        
        
        addSubview(toolBar)
        
        
        addSubview(containerView)
        containerView.addSubview(storeNameLabel)
        containerView.addSubview(storeCategoryLabel)
        

        toolBar.snp.makeConstraints {
            $0.leading.trailing.bottom.equalTo(safeAreaLayoutGuide)
            $0.height.equalTo(toolBar.toolBar)
        }
        containerView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.bottom.equalTo(toolBar.snp.top).offset(-16)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        storeNameLabel.snp.makeConstraints {
            $0.top.equalTo(containerView)
            $0.leading.equalTo(containerView)
        }
        storeCategoryLabel.snp.makeConstraints {
            $0.leading.equalTo(storeNameLabel.snp.trailing).offset(8)
            $0.top.equalTo(storeNameLabel)
            $0.height.equalTo(storeNameLabel)
        }
        

        
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
