//
//  CommonViewController.swift
//  TapPlace
//
//  Created by 박상현 on 2022/08/20.
//

import UIKit

class CommonViewController: UIViewController {
    var tabBar: TabBarViewController?
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let customTabBar = tabBarController as? TabBarViewController else { return }
        tabBar = customTabBar
    }
}
