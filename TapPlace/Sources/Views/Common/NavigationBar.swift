//
//  NavigationBar.swift
//  TapPlace
//
//  Created by 이상준 on 2022/08/20.
//

import UIKit

protocol BackButtonProtocol {
    func popViewVC()
}

class NavigationBar: UIView {
    
    // 뒤로가기 버튼
    let backButton: UIButton = {
        let backButton = UIButton()
        backButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        backButton.tintColor = .gray
        backButton.addTarget(self, action: #selector(popVC), for: .touchUpInside)
        return backButton
    }()
    
    var delegate: BackButtonProtocol?
    
    var title: String = "" {
        willSet {
            if newValue != "" {
                let titleLabel: UILabel = {
                    let titleLabel = UILabel()
                    titleLabel.sizeToFit()
                    titleLabel.text = newValue
                    titleLabel.textColor = .black
                    titleLabel.font = .systemFont(ofSize: CommonUtils.resizeFontSize(size: 17), weight: .regular)
                    return titleLabel
                }()
                navigationBar.addSubview(titleLabel)
                titleLabel.snp.makeConstraints {
                    $0.leading.equalTo(backButton.snp.trailing).offset(10)
                    $0.centerY.equalTo(backButton)
                }
            }
        }
    }
    
    // 상단 검색 뷰
    let navigationBar: UIView = {
        let navigationBar = UIView()
        navigationBar.backgroundColor = .white
        return navigationBar
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        addSubview(navigationBar)
        navigationBar.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        navigationBar.addSubview(backButton)
        backButton.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.top).offset(24)
            $0.leading.equalTo(navigationBar.snp.leading).offset(16)
            $0.width.height.equalTo(25)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension NavigationBar {
    @objc func popVC() {
        delegate?.popViewVC()
    }
}
