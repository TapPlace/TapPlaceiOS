//
//  StoreTabCollectionViewCell.swift
//  TapPlace
//
//  Created by 박상현 on 2022/08/12.
//

import UIKit

class StoreTabCollectionViewCell: UICollectionViewCell {
    let itemFrame: UIView = {
        let itemFrame = UIView()
        itemFrame.backgroundColor = .white
        itemFrame.layer.cornerRadius = 14
        itemFrame.layer.applySketchShadow(color: .black, alpha: 0.12, x: 0, y: 2, blur: 8, spread: 0)
        return itemFrame
    }()
    let itemText: UILabel = {
        let itemText = UILabel()
        itemText.text = ""
        itemText.sizeToFit()
        itemText.font = .systemFont(ofSize: CommonUtils().resizeFontSize(size: 14), weight: .regular)
        itemText.layer.opacity = 0.7
        return itemText
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        

        addSubview(itemFrame)
        itemFrame.addSubview(itemText)
        
        
        itemFrame.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalTo(itemText).offset(-10)
            $0.trailing.equalTo(itemText).offset(10)
            $0.height.equalTo(28)
        }
        itemText.snp.makeConstraints {
            $0.centerX.centerY.equalTo(itemFrame)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
