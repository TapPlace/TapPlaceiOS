//
//  TestViewController.swift
//  TapPlace
//
//  Created by 박상현 on 2022/09/05.
//

import UIKit

class TestViewController: CommonViewController, CustomNavigationBarProtocol {
    func didTapLeftButton() {
        print("뷰컨트롤에서 함수 실행됨")
    }
    

    let customNavigationBar = CustomNavigationBar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white

        customNavigationBar.delegate = self
        customNavigationBar.isDrawShadow = false
        customNavigationBar.isDrawBottomLine = true
        customNavigationBar.titleText = "네비게이션바 타이틀"
        customNavigationBar.isUseLeftButton = true
        customNavigationBar.leftButtonImage = UIImage(systemName: "bell")!
        
        view.addSubview(customNavigationBar)
        customNavigationBar.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(customNavigationBar.containerView)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBar?.showTabBar(hide: true)
    }
}
