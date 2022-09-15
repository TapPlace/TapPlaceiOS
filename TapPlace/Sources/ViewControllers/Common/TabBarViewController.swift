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
        floatingButton.layer.shadowColor = UIColor(hex: 0xABBFFF).cgColor
        floatingButton.layer.shadowRadius = 12
        floatingButton.layer.shadowOpacity = 1
        floatingButton.layer.shadowOffset = CGSize(width: 0, height: 4)
        //floatingButton.isHidden = true // 베타버전 임시 강제 true
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
    
    // 플로팅 버튼 클릭 여부
    var isClickFloatingButton: Bool? = false
    var tempViewHeight: CGFloat = 0
    var mainVC: UIViewController?
    
    private let optionMenu = UIAlertController(title: nil, message: "New", preferredStyle: .actionSheet)
    
        let indicatorView: UIView = {
            let indicatorView = UIView()
            indicatorView.backgroundColor = .white
            return indicatorView
        }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isHidden = true
        
        
        self.tabBar.layer.applySketchShadow(color: .black, alpha: 0.12, x: 0, y: 0, blur: 14, spread: 0)
        
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
        
        mainVC = viewControllers[0].controller
        
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
    
    // 플로팅 버튼 클릭시 이벤트
    @objc private func menuButtonAction(sender: UIButton) {
//        print("플로팅 버튼 클릭")
        guard let mainVC = mainVC as? MainViewController else { return }
        mainVC.clickFloatingBtn()
    }
    
    /**
     * @ 탭바 처리
     * coder : sanghyeon
     */
    func showTabBar(hide: Bool) {
        if hide {
            self.tabBar.isHidden = true
            self.floatingButton.isHidden = true // 베타버전 임시 주석
        } else {
            self.tabBar.isHidden = false
            self.floatingButton.isHidden = false // 베타버전 임시 주석
        }
        let currentFrame = view.frame
        view.frame = currentFrame.insetBy(dx: 0, dy: 1)
        view.frame = currentFrame
    }
    
    /**
     * @ 메인뷰컨트롤러 스토어 상세뷰
     * coder : sanghyeon
     */
    func showStoreInfo(storeID: String, isShowNavigation: Bool = true) {
        if let mainNav = viewControllers?[0] as? UINavigationController {
            if let mainVC = mainNav.children.first as? MainViewController {
//                print("mainVC:", mainVC)
                mainVC.showDetailOverView(hide: false)
                if isShowNavigation {
                    mainVC.showNavigationBar(hide: false, title: "스토어 이름")
                }
            }
        }
    }
}
