//
//  MoreHeaderViewItem.swift
//  TapPlace
//
//  Created by 박상현 on 2022/09/06.
//

import UIKit

protocol MoreHeaderButtonProtocol {
    func didTapMoreHeaderItemButton(_ sender: UIButton)
}

class MoreHeaderViewItem: UIView {
    
    var delegate: MoreHeaderButtonProtocol?
    
    var countOfItem: Int = 0 {
        willSet {
            countLabel.text = String(newValue)
        }
    }
    
    var title: String = "" {
        willSet {
            itemTitleLabel.text = newValue
        }
    }

    let itemFrame = UIView()
    
    let countLabel: UILabel = {
        let countLabel = UILabel()
        countLabel.sizeToFit()
        countLabel.textColor = .black
        countLabel.font = .systemFont(ofSize: CommonUtils.resizeFontSize(size: 20), weight: .regular)
        countLabel.text = "0"
        return countLabel
    }()
    let itemTitleLabel: UILabel = {
        let itemTitleLabel = UILabel()
        itemTitleLabel.sizeToFit()
        itemTitleLabel.textColor = .init(hex: 0x333333)
        itemTitleLabel.font = .systemFont(ofSize: CommonUtils.resizeFontSize(size: 14), weight: .medium)
        return itemTitleLabel
    }()
    let button: UIButton = {
        let button = UIButton()
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension MoreHeaderViewItem {
    /**
     * @ 초기 레이아웃 설정
     * coder : sanghyeon
     */
    func setupView() {
        //MARK: AddSubView
        self.addSubview(itemFrame)
        itemFrame.addSubview(countLabel)
        itemFrame.addSubview(itemTitleLabel)
        itemFrame.addSubview(button)
        
        //MARK: ViewContraints
        itemFrame.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(countLabel)
            $0.bottom.equalTo(itemTitleLabel)
            $0.centerY.equalToSuperview()
        }
        countLabel.snp.makeConstraints {
            $0.top.equalTo(itemFrame)
            $0.centerX.equalTo(itemFrame)
        }
        itemTitleLabel.snp.makeConstraints {
            $0.top.equalTo(countLabel.snp.bottom).offset(10)
            $0.centerX.equalTo(itemFrame)
        }
        button.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        //MARK: ViewAddTarget
        button.addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside)
        
        
        //MARK: Delegate
    }
    
    @objc func didTapButton(_ sender: UIButton) {
        delegate?.didTapMoreHeaderItemButton(sender)
    }
}
