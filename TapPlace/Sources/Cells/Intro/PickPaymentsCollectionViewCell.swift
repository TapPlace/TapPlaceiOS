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
    
    //MARK: 컬렉션뷰 UI에 사용될 색깔 배열 지정 (true/false 순서)
    let colorBorder: [UIColor] = [.disabledBorderColor, .activateBorderColor]
    let widthBorder: [CGFloat] = [1, 1.5]
    let colorBackground: [UIColor] = [.clear, .activateBackgroundColor]
    let colorText: [UIColor] = [.disabledTextColor, .pointBlue]
    let activeCell: [Bool] = [false, true]
    let colorImage: [UIColor] = [.disabledImageColor, .pointBlue]
    
    var cellSelected: Bool = false {
        willSet {
            let arrRow = newValue ? 1 : 0
            UIView.animate(withDuration: 0.2, delay: 0, animations: {
                self.itemText.textColor = self.colorText[arrRow]
                self.itemFrame.backgroundColor = self.colorBackground[arrRow]
                self.itemFrame.layer.borderWidth = self.widthBorder[arrRow]
                self.itemFrame.layer.borderColor = self.colorBorder[arrRow].cgColor
            })
        }
    }
    var cellVariable: String = ""
    
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.prepare()
    }
    
    func prepare() {
        self.cellSelected = false
    }
    
    @objc func didTapItem() {
        //delegate?.didTapPaymentsItem()
    }
}
