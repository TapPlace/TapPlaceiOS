//
//  PickStoresCollectionViewCell.swift
//  TapPlace
//
//  Created by 박상현 on 2022/08/10.
//

import UIKit

class PickStoresCollectionViewCell: UICollectionViewCell {

    var cellSelected: Bool = false
    let itemFrame: UIView = {
        let itemFrame = UIView()
        itemFrame.layer.borderWidth = 1
        itemFrame.layer.borderColor = UIColor.init(hex: 0xDBDEE8, alpha: 0.5).cgColor
        itemFrame.layer.cornerRadius = 18
        return itemFrame
    }()
    
    let itemWrap: UIView = {
        let itemWrap = UIView()
        return itemWrap
    }()
    let itemText: UILabel = {
        let itemText = UILabel()
        itemText.text = "카페/디저트"
        itemText.sizeToFit()
        itemText.textColor = .disabledTextColor
        itemText.font = .systemFont(ofSize: CommonUtils.resizeFontSize(size: 14), weight: .regular)
        return itemText
    }()
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .clear
        imageView.tintColor = .disabledImageColor
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        guard let text = itemText.text else { return }
        let labelSize = CommonUtils.getTextSizeWidth(text: text)
        
        addSubview(itemFrame)
        addSubview(itemWrap)
        itemWrap.addSubview(itemText)
        itemWrap.addSubview(imageView)
        
        itemFrame.snp.makeConstraints {
            $0.top.bottom.leading.trailing.equalToSuperview()
        }
        itemWrap.snp.makeConstraints {
            $0.centerX.equalTo(itemFrame)
            $0.centerY.equalTo(itemFrame).offset(5)
            $0.leading.trailing.equalTo(itemFrame)
            $0.top.equalTo(imageView)
            $0.bottom.equalTo(itemText)
        }
        itemText.snp.makeConstraints {
            $0.centerX.equalTo(itemWrap)
            $0.bottom.equalTo(itemWrap)
        }
        imageView.snp.makeConstraints {
            $0.centerX.equalTo(itemWrap)
        }

        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(Int(0.1))) {
            let imageSize = self.frame.size.height - labelSize.height - 50
            self.imageView.snp.makeConstraints {
                $0.bottom.equalTo(self.itemText.snp.top).offset(-15)
                $0.width.height.equalTo(imageSize)
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
