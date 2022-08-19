//
//  PickPaymentsCollectionViewCell.swift
//  TapPlace
//
//  Created by 박상현 on 2022/08/09.
//

import UIKit

protocol PickPaymentsProtocol {
    func didTapPaymentsItem()
}

class PickPaymentsCollectionViewCell: UICollectionViewCell {
    var delegate: PickPaymentsProtocol?
    var cellSelected: Bool = false
    let itemFrame: UIView = {
        let itemFrame = UIView()
        itemFrame.frame.size.height = 36
        itemFrame.layer.borderWidth = 1
        itemFrame.layer.borderColor = UIColor.disabledBorderColor.cgColor
        itemFrame.layer.cornerRadius = 18
        return itemFrame
    }()
    let itemText: UILabel = {
        let itemText = UILabel()
        itemText.sizeToFit()
        itemText.textColor = .disabledTextColor
        itemText.font = .systemFont(ofSize: CommonUtils.resizeFontSize(size: 14), weight: .regular)
        return itemText
    }()

    override init(frame: CGRect) {
        super.init(frame: .zero)
        addSubview(itemFrame)
        itemFrame.addSubview(itemText)

        itemFrame.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.equalTo(itemText).offset(-20)
            $0.trailing.equalTo(itemText).offset(20)
        }
        itemText.snp.makeConstraints {
            $0.centerY.centerX.equalTo(itemFrame)
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    @objc func didTapItem() {
        //delegate?.didTapPaymentsItem()
    }
}
