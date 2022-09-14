//
//  MoreMenuTableViewCell.swift
//  TapPlace
//
//  Created by 박상현 on 2022/09/06.
//

import UIKit

class MoreMenuTableViewCell: UITableViewCell {

    static let cellId = "menuItem"
    var menuType: MoreMenuModel.MoreMenuType?
    
    var title: String = "" {
        willSet {
            menuTitleLabel.text = newValue
        }
    }
    
    var subTitle: String = "" {
        willSet {
            if newValue != "" {
                menuSubTitleLabel.text = newValue
                self.addSubview(menuSubTitleLabel)
                menuSubTitleLabel.snp.makeConstraints {
                    $0.trailing.equalToSuperview().offset(-20)
                    $0.centerY.equalToSuperview()
                }
            } else {
                
            }
        }
    }
    
    let menuTitleLabel: UILabel = {
        let menuTitleLabel = UILabel()
        menuTitleLabel.sizeToFit()
        menuTitleLabel.textColor = .init(hex: 0x4D4D4D)
        menuTitleLabel.font = .systemFont(ofSize: CommonUtils.resizeFontSize(size: 15), weight: .medium)
        return menuTitleLabel
    }()
    
    let menuSubTitleLabel: UILabel = {
        let menuSubTitleLabel = UILabel()
        menuSubTitleLabel.sizeToFit()
        menuSubTitleLabel.textColor = .init(hex: 0x9E9E9E)
        menuSubTitleLabel.font = .systemFont(ofSize: CommonUtils.resizeFontSize(size: 13), weight: .regular)
        return menuSubTitleLabel
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super .init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        menuSubTitleLabel.text = ""
    }
}

extension MoreMenuTableViewCell {
    func setupCell() {
        self.addSubview(menuTitleLabel)
        
        menuTitleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.centerY.equalToSuperview()
        }
    }
}
