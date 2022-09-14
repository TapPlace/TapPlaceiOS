//
//  FAQViewController.swift
//  TapPlace
//
//  Created by 이상준 on 2022/09/08.
//

import Foundation
import UIKit

class FAQViewController: UIViewController {
    
    let customNavigationBar = CustomNavigationBar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setLayout()
        
        customNavigationBar.delegate = self
        customNavigationBar.isDrawShadow = false
        customNavigationBar.isDrawBottomLine = false
        customNavigationBar.titleText = "자주 묻는 질문"
        customNavigationBar.isUseLeftButton = true
    }
}

extension FAQViewController {
    private func setupView() {
        self.view.backgroundColor = .white
    }
    
    private func setLayout() {
        view.addSubview(customNavigationBar)
        customNavigationBar.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(customNavigationBar.containerView)
        }
    }
}

// MARK: - 커스텀 네비게이션 바 프로토콜 구현
extension FAQViewController: CustomNavigationBarProtocol {
    func didTapLeftButton() {
        self.navigationController?.popViewController(animated: true)
    }
}
