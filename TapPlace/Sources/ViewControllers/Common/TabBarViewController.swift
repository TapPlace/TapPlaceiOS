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
        tempView.backgroundColor = .clear
        return tempView
    }()
    
    let floatingButton: UIButton = {
        let floatingButton = UIButton()
        floatingButton.backgroundColor = .pointBlue
        floatingButton.layer.cornerRadius = 25
        floatingButton.layer.shadowColor = UIColor.black.cgColor
        floatingButton.layer.shadowRadius = 3
        floatingButton.layer.shadowOpacity = 0.3
        floatingButton.layer.shadowOffset = CGSize(width: 0, height: 3)
        return floatingButton
    }()
    
    var isShowFloatingButton: Bool = true {
        willSet {
            if newValue {
                floatingButton.isHidden = false
            } else {
                floatingButton.isHidden = true
            }
        }
    }
    
    var tempViewHeight: CGFloat = 0
    
    private let optionMenu = UIAlertController(title: nil, message: "New", preferredStyle: .actionSheet)
    
        let indicatorView: UIView = {
            let indicatorView = UIView()
            indicatorView.backgroundColor = .white
            return indicatorView
        }()

    override func viewDidLoad() {
        super.viewDidLoad()
        

        
        tabBar.tintColor = .tabBarTintColor
        tabBar.unselectedItemTintColor = .tabBarUnTintColor
        tabBar.backgroundColor = .white
        
        tabBar.addSubview(tempView)
        tabBar.addSubview(floatingButton)
        
        if #available(iOS 13.0, *) {
            let window = UIApplication.shared.windows.first
            let top = window?.safeAreaInsets.top
            let bottom = window?.safeAreaInsets.bottom
            let tabBarHeight = self.tabBar.frame.height
            tempViewHeight = tabBarHeight
        }
        
        
        tabBar.addSubview(indicatorView)
        indicatorView.snp.makeConstraints {
            $0.bottom.equalTo(tabBar.snp.top)
            $0.leading.trailing.equalTo(tabBar)
            $0.height.equalTo(1.5)
        }
        
        tempView.snp.makeConstraints {
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalTo(indicatorView).offset(tempViewHeight)
            $0.height.equalTo(tempViewHeight)
        }
        
        let menuButtonFrame = floatingButton.frame


        let iconImage: UIImageView = {
            let iconConfig = UIImage.SymbolConfiguration(pointSize: 24, weight: .medium, scale: .medium)
            let iconImage = UIImageView()
            iconImage.image = UIImage(systemName: "plus", withConfiguration: iconConfig)
            iconImage.tintColor = .white
            return iconImage
        }()
        
        floatingButton.frame = menuButtonFrame

        floatingButton.addSubview(iconImage)
        iconImage.snp.makeConstraints {
            $0.width.height.equalTo(30)
            $0.centerX.centerY.equalTo(floatingButton)
        }
        view.addSubview(floatingButton)
        floatingButton.snp.makeConstraints {
            $0.centerX.equalTo(indicatorView)
            $0.centerY.equalTo(indicatorView)
            $0.width.height.equalTo(50)
        }

        floatingButton.addTarget(self, action: #selector(menuButtonAction(sender:)), for: .touchUpInside)

        let viewControllers: [ViewControllers] = [
            ViewControllers(controller: MainViewController(), title: "주변", icon: UIImage(named: "location")!),
            ViewControllers(controller: MoreViewController(), title: "더보기", icon: UIImage(named: "more")!)
        ]
        
        setViewControllers(setVC(vc: viewControllers), animated: true)
        
        view.layoutIfNeeded()
    }
    
        override func viewDidLayoutSubviews() {
            super.viewDidLayoutSubviews()
    
            self.tabBar.itemPositioning = .centered
            self.tabBar.itemSpacing = UIScreen.main.bounds.width / 3
    
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(Int(0.3))) {
                let size = CGSize(width: (self.tabBar.frame.width / CGFloat(2)) - 130,
                                  height: self.tabBar.frame.height + 1.5)
                let image = UIImage().createSelectionIndicator(color: .pointBlue, size: size, lineWidth: 2.0)
                self.tabBar.selectionIndicatorImage = image
                UITabBar.appearance().selectionIndicatorImage = image
                self.tabBar.selectionIndicatorImage = image
            }
        }

    func setVC(vc: [ViewControllers]) -> [UIViewController] {
        var tempVCArray: [UIViewController] = []
        for i in 0...vc.count - 1 {
            let tempVC = UINavigationController(rootViewController: vc[i].controller)
            tempVC.navigationController?.navigationBar.isHidden = true
            tempVC.tabBarItem.title = vc[i].title
            tempVC.tabBarItem.image = vc[i].icon
            tempVCArray.append(tempVC)
        }
        
        return tempVCArray
    }
    
    @objc private func menuButtonAction(sender: UIButton) {
        print("플로팅버튼 눌림")
    }
    
    /**
     * @ 탭바 처리
     * coder : sanghyeon
     */
    func showTabBar(hide: Bool) {
        if hide {
            self.tabBar.isHidden = true
            self.floatingButton.isHidden = true
        } else {
            self.tabBar.isHidden = false
            self.floatingButton.isHidden = false
        }
        let currentFrame = view.frame
        view.frame = currentFrame.insetBy(dx: 0, dy: 1)
        view.frame = currentFrame
    }
}
