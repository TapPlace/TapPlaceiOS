//
//  StoreTabCollectionViewCell.swift
//  TapPlace
//
//  Created by 박상현 on 2022/08/12.
//

import UIKit

class StoreTabCollectionViewCell: UICollectionViewCell {
    var icon: UIImage = UIImage() {
        willSet {
            itemIcon.image = newValue.withAlignmentRectInsets(UIEdgeInsets(top: -7, left: 0, bottom: -7, right: 0))
        }
    }
    let itemFrame: UIView = {
        let itemFrame = UIView()
        itemFrame.backgroundColor = .white
        itemFrame.layer.cornerRadius = 14
        itemFrame.layer.applySketchShadow(color: .black, alpha: 0.12, x: 0, y: 2, blur: 8, spread: 0)
        return itemFrame
    }()
    let itemIcon: UIImageView = {
        let itemIcon = UIImageView()
        itemIcon.image = UIImage(systemName: "apple.logo")
        itemIcon.tintColor = .black
        itemIcon.contentMode = .scaleAspectFit
        return itemIcon
    }()
    let itemText: UILabel = {
        let itemText = UILabel()
        itemText.text = ""
        itemText.sizeToFit()
        itemText.font = .systemFont(ofSize: CommonUtils.resizeFontSize(size: 14), weight: .regular)
        itemText.layer.opacity = 0.7
        return itemText
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        

        addSubview(itemFrame)
        itemFrame.addSubview(itemIcon)
        itemFrame.addSubview(itemText)
        
        
        itemFrame.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalTo(itemIcon).offset(-10)
            $0.trailing.equalTo(itemText).offset(10)
            $0.height.equalTo(28)
        }
        itemIcon.snp.makeConstraints {
            $0.centerY.equalTo(itemFrame)
            $0.width.equalTo(15)
        }
        itemText.snp.makeConstraints {
            $0.leading.equalTo(itemIcon.snp.trailing).offset(3)
            $0.centerY.equalTo(itemIcon)
        
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static func fittingSize(availableHeight: CGFloat, name: String?) -> CGSize {
        let cell = StoreTabCollectionViewCell()
        
        let targetSize = CGSize(width: UIView.layoutFittingCompressedSize.width, height: availableHeight)
        return cell.itemFrame.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: .fittingSizeLevel, verticalFittingPriority: .required)
    }
    
}