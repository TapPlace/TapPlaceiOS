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
    
    let tempView: UIView = {
        let tempView = UIView()
        return tempView
    }()
    
    let floatingButton: UIButton = {
        let floatingButton = UIButton()
        floatingButton.backgroundColor = .pointBlue
        let config = UIImage.SymbolConfiguration(pointSize: 16, weight: .regular, scale: .large)
        floatingButton.setImage(UIImage(systemName: "plus", withConfiguration: config), for: .normal)
        floatingButton.tintColor = .white
        floatingButton.addTarget(self, action: #selector(didTapFloatingButton), for: .touchUpInside)
        return floatingButton
    }()
    
    let indicatorView: UIView = {
        let indicatorView = UIView()
        indicatorView.backgroundColor = .white
        return indicatorView
    }()
    
    var tempViewHeight: CGFloat = 0
    
    
    override var tabBar: UITabBar {
        return CustomTabBar()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        self.tabBar.backgroundColor = .white
        self.tabBar.tintColor = .tabBarTintColor
        self.tabBar.unselectedItemTintColor = .tabBarUnTintColor
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(Int(0.3))) {
            let size = CGSize(width: (self.tabBar.frame.width / CGFloat(2)) - 130,
                              height: self.tabBar.frame.height + 1.5)
            let image = UIImage().createSelectionIndicator(color: .pointBlue, size: size, lineWidth: 2.0)
            self.tabBar.selectionIndicatorImage = image
            
            UITabBar.appearance().selectionIndicatorImage = image
            self.tabBar.selectionIndicatorImage = image // this will change color and height of current tabBar
        }
        
        self.tabBar.addSubview(indicatorView)
        
        self.tabBar.addSubview(tempView)
        tempView.addSubview(floatingButton)

        if #available(iOS 13.0, *) {
            let window = UIApplication.shared.windows.first
            let top = window?.safeAreaInsets.top
            let bottom = window?.safeAreaInsets.bottom
            print("top : \(String(describing: top))")
            print("bottom : \(String(describing: bottom))")
            let tabBarHeight = self.tabBar.frame.height
            guard let safeAreaHeight = bottom else { return }
            print("tabBarHeight:", tabBarHeight)
            tempViewHeight = tabBarHeight
        }


        tempView.snp.makeConstraints {
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalTo(indicatorView).offset(tempViewHeight / 2)
            $0.height.equalTo(tempViewHeight)
        }

        floatingButton.snp.makeConstraints {
            $0.centerX.equalTo(tempView)
            $0.height.equalTo(tempView.snp.height)
            $0.width.equalTo(tempView.snp.height)
        }
        
        indicatorView.snp.makeConstraints {
            $0.bottom.equalTo(tabBar.snp.top)
            $0.leading.trailing.equalTo(tabBar)
            $0.height.equalTo(1.5)
        }


        
        let viewControllers: [ViewControllers] = [
            ViewControllers(controller: MainViewController(), title: "주변", icon: UIImage(systemName: "location.circle")!),
            ViewControllers(controller: MoreViewController(), title: "더보기", icon: UIImage(systemName: "ellipsis.circle")!)
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
    
    @objc func didTapFloatingButton() {
        print("플로팅 버튼 호출")
    }

}


extension TabBarViewController {
    
}
