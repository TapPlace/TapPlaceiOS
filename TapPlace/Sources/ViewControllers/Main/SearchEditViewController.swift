//
//  SearchEditViewController.swift
//  TapPlace
//
//  Created by 이상준 on 2022/08/20.
//

import UIKit

class SearchEditViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue
    }
}

extension SearchEditViewController {
    
    private func setupView() {
        
        
    }
    
    private func layOut() {
        
        
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // 탭바
        guard let tabBar = tabBarController as? TabBarViewController else { return }
        print("뷰 사라집니다.")
        tabBar.showTabBar(hide: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 탭바
        guard let tabBar = tabBarController as? TabBarViewController else { return }
        print("뷰 나타납니다.")
        tabBar.showTabBar(hide: true)
    }
}
