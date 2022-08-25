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
    
    let backButton = UIButton()
    var delegate: BackButtonProtocol?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        // 상단 검색 뷰
        let navigationBar: UIView = {
            let navigationBar = UIView()
            navigationBar.backgroundColor = .white
            return navigationBar
        }()
        
        // 뒤로가기 버튼
        let backButton: UIButton = {
            let backButton = UIButton()
            backButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
            backButton.tintColor = .gray
            backButton.addTarget(self, action: #selector(movePopVC), for: .touchUpInside)
            return backButton
        }()
        
        
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
    @objc func movePopVC() {
        delegate?.popViewVC()
    }
}
