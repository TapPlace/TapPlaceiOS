//
//  BookMarkEditModeCell.swift
//  TapPlace
//
//  Created by 박상현 on 2022/09/07.
//

import UIKit


class BookMarkEditModeCell: UITableViewCell {

    static let cellId = "bookmarkEditItem"
    
    var cellIndex: Int = 0 {
        willSet {
            storeInfoView.thisIndex = newValue
        }
    }
    
    var cellSelected: Bool = false {
        willSet {
            if newValue {
                print("아이콘 색상이 포인트 블루로 변경될 예정")
                iconImage.tintColor = .pointBlue
            } else {
                iconImage.tintColor = .init(hex: 0xCDD2DF)
            }
        }
    }
    
    var isEditMode: Bool = false {
        willSet {
            if newValue {
                storeInfoView.snp.updateConstraints {
                    $0.leading.equalToSuperview().offset(50)
                }
                iconFrame.isHidden = false
            } else {
                storeInfoView.snp.updateConstraints {
                    $0.leading.equalToSuperview()
                }
                iconFrame.isHidden = true
            }
        }
    }
    
    var storeInfo: StoreInfo = StoreInfo.emptyStoreInfo {
        willSet {
            storeInfoView.storeInfo = newValue
        }
    }

    let storeInfoView = StoreInfoView()
    let iconFrame = UIView()
    var iconImage = UIImageView()
    
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
        iconImage.tintColor = .init(hex: 0xCDD2DF)
    }
}
extension BookMarkEditModeCell {
    func setupCell() {
        iconImage = {
            let iconImage = UIImageView()
            iconImage.contentMode = .scaleAspectFit
            iconImage.image = UIImage(named: "checkmark")?.withRenderingMode(.alwaysTemplate)
            iconImage.tintColor = .init(hex: 0xCDD2DF)
            return iconImage
        }()
        
        addSubview(storeInfoView)
        addSubview(iconFrame)
        iconFrame.addSubview(iconImage)
        
        storeInfoView.snp.makeConstraints {
            $0.top.bottom.trailing.equalToSuperview()
            $0.leading.equalToSuperview().offset(50)
        }
        iconFrame.snp.makeConstraints {
            $0.top.leading.bottom.equalToSuperview()
            $0.width.equalTo(50)
        }
        iconImage.snp.makeConstraints {
            $0.width.height.equalTo(15)
            $0.centerY.equalTo(iconFrame)
            $0.centerX.equalTo(iconFrame).offset(-5)
        }
        
    }
    

}
