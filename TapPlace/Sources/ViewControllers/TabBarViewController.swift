//
//  TabBarViewController.swift
//  TapPlace
//
//  Created by 박상현 on 2022/08/12.
//

import UIKit

class TabBarViewController: UITabBarController {

    struct ViewControllers {
        let controller: UIViewController
        let title: String
        let icon: UIImage
    }
    
    let indicatorView: UIView = {
        let indicatorView = UIView()
        indicatorView.backgroundColor = .pointBlue
        return indicatorView
    }()
    
    let floatingButton: UIView = {
        let floatingButton = UIView()
        floatingButton.backgroundColor = .pointBlue
        return floatingButton
    }()
    
    let tempView: UIView = {
        let tempView = UIView()
        return tempView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        self.tabBar.tintColor = .tabBarTintColor
        self.tabBar.unselectedItemTintColor = .tabBarUnTintColor
        


        
        self.tabBar.addSubview(indicatorView)
        self.tabBar.addSubview(tempView)
        self.tabBar.addSubview(floatingButton)
        
        indicatorView.snp.makeConstraints {
            $0.bottom.equalTo(tabBar.snp.top)
            $0.leading.trailing.equalTo(tabBar)
            $0.height.equalTo(1.5)
        }
        tempView.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(tabBar)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        floatingButton.snp.makeConstraints {
            $0.centerX.centerY.equalTo(indicatorView)
            $0.height.equalTo(tempView.snp.height)
            $0.width.equalTo(tempView.snp.height)
        }
        
        
        let viewControllers: [ViewControllers] = [
            ViewControllers(controller: MainViewController(), title: "주변", icon: UIImage(systemName: "location.circle")!),
            ViewControllers(controller: MyPageViewController(), title: "더보기", icon: UIImage(systemName: "ellipsis.circle")!)
        ]

        setViewControllers(setVC(vc: viewControllers), animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.tabBar.itemPositioning = .centered
        self.tabBar.itemSpacing = UIScreen.main.bounds.width / 3
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(Int(0.3))) {
            print("height:", self.tempView.frame.height)
            self.floatingButton.layer.cornerRadius = self.tempView.bounds.height / 2
        }
    }

    func setVC(vc: [ViewControllers]) -> [UIViewController] {
        var tempVCArray: [UIViewController] = []
        for i in 0...vc.count - 1 {
            print(vc[i].title)
            let tempVC = UINavigationController(rootViewController: vc[i].controller)
            tempVC.navigationController?.navigationBar.isHidden = true
            tempVC.tabBarItem.title = vc[i].title
            tempVC.tabBarItem.image = vc[i].icon
            tempVCArray.append(tempVC)
        }

        return tempVCArray
    }

}


extension TabBarViewController {
    
}
