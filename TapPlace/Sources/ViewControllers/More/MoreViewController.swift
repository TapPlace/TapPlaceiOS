//
//  MoreViewController.swift
//  TapPlace
//
//  Created by 박상현 on 2022/08/13.
//

import UIKit
import NMapsMap

class MoreViewController: CommonViewController {
    let storageViewModel = StorageViewModel()
    var headerView: MoreHeaderView?
    let customNavigationBar = CustomNavigationBar()
    let menuList = MoreMenuModel.list
    
    var navigationButtonStackView = UIStackView()
    var spacerView = UIView()
    let alarmButton = NavigationBarButton()
    let settingButton = NavigationBarButton()
    let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupNavigation()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        headerView?.countOfBookmark = storageViewModel.numberOfBookmark
    }
}
//MARK: - Layouyt
extension MoreViewController: NavigationBarButtonProtocol {
    /**
     * @ 초기 레이아웃 설정
     * coder : sanghyeon
     */
    func setupView() {
        //MARK: ViewDefine
        let safeArea = view.safeAreaLayoutGuide
        
        
        //MARK: ViewPropertyManual
        self.view.backgroundColor = .white
        navigationButtonStackView = {
            let navigationButtonStackView = UIStackView()
            navigationButtonStackView.axis = .horizontal
            navigationButtonStackView.spacing = 20
            return navigationButtonStackView
        }()
        spacerView = {
            let spacerView = UIView()
            spacerView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
            return spacerView
        }()
        
        
        //MARK: AddSubView
        self.view.addSubview(customNavigationBar)
        customNavigationBar.addSubview(navigationButtonStackView)
        navigationButtonStackView.addArrangedSubviews([spacerView, alarmButton, settingButton])
        self.view.addSubview(tableView)
        
        //MARK: ViewContraints
        customNavigationBar.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(customNavigationBar.containerView)
        }
        navigationButtonStackView.snp.makeConstraints {
            $0.leading.equalTo(customNavigationBar.navigationTitleLabel.snp.trailing).offset(10)
            $0.trailing.equalTo(customNavigationBar).offset(-20)
            $0.centerY.equalTo(customNavigationBar.navigationTitleLabel)
            $0.height.equalTo(40)
        }
        alarmButton.snp.makeConstraints {
            $0.width.equalTo(20)
        }
        settingButton.snp.makeConstraints {
            $0.width.equalTo(30)
        }
        tableView.snp.makeConstraints {
            $0.top.equalTo(customNavigationBar.snp.bottom)
            $0.leading.trailing.bottom.equalTo(safeArea)
        }
        
        //MARK: ViewAddTarget
        
        
        //MARK: Delegate
        tableView.delegate = self
        tableView.dataSource = self
    }
    /**
     * @ 네비게이션 세팅
     * coder : sanghyeon
     */
    func setupNavigation() {
        
        self.navigationController?.navigationBar.isHidden = true
        
        customNavigationBar.titleText = "더보기"
        
        alarmButton.setImage = "alarm"
        alarmButton.delegate = self
        settingButton.setImage = "gear"
        settingButton.delegate = self
    }
    /**
     * @ 네비게이션바 버튼 클릭 함수
     * coder : sanghyeon
     */
    func didTapNavigationBarButton(_ sender: UIButton) {
        switch sender {
        case alarmButton:
            let vc = AlarmViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        case settingButton:
            print("네비게이션 설정 버튼 탭")
        default:
            break
        }
    }
    /**
     * @ 테이블뷰 세팅
     * coder : sanghyeon
     */
    func setupTableView() {
        tableView.register(MoreMenuTableViewCell.self, forCellReuseIdentifier: MoreMenuTableViewCell.cellId)
        tableView.separatorStyle = .none
    }
}

//MARK: - TableView
extension MoreViewController: UITableViewDelegate, UITableViewDataSource, MoreHeaderButtonProtocol {
    func didTapMoreHeaderItemButton(_ sender: UIButton) {
        guard let headerView = headerView else { return }
        switch sender {
        case headerView.itemBookmark.button:
            print("즐겨찾기 탭")
            let vc = BookmarkViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        case headerView.itemFeedback.button:
            print("피드백 탭")
            let vc = FeedbackListViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        case headerView.itemStores.button:
            print("등록가게 탭")
        default:
            break
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
   
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return menuList.count
        case 1:
            return TermsModel.lists.filter({$0.isTerm == true}).count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MoreMenuTableViewCell.cellId, for: indexPath) as? MoreMenuTableViewCell else { return UITableViewCell() }
        cell.selectionStyle = .none
        switch indexPath.section {
        case 0:
            cell.title = menuList[indexPath.row].title
            cell.menuType = menuList[indexPath.row].type
            if let subTitle = menuList[indexPath.row].subTitle {
                switch subTitle {
                case .version:cell.subTitle = "최신버전"
                default: break
                }
            }
            return cell
        case 1:
            let targetTerm = TermsModel.lists.filter({$0.isTerm == true})
            cell.title = targetTerm[indexPath.row].title
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            guard let cell = tableView.cellForRow(at: indexPath) as? MoreMenuTableViewCell else { return }
            let inquiryVC = InquiryViewController()
            if let vc = menuList[indexPath.row].vc {
                if vc == inquiryVC {
                    inquiryVC.type = menuList[indexPath.row].type
                }
                self.navigationController?.pushViewController(vc, animated: true)
                
                return
            }
            if let type = cell.menuType {
                switch type {
                case .version:
                    break
                case .reset:
                    self.dismiss(animated: true)
                    self.present(OnBoardingViewController(), animated: true)
                default: break
                }
            }
        case 1:
            break
        default: break
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    //MARK: Header & Footer
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            headerView = MoreHeaderView()
            headerView?.itemBookmark.delegate = self
            headerView?.itemFeedback.delegate = self
            headerView?.itemStores.delegate = self
            return headerView
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 150
        }
        return 0
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == 0 {
            let footerView: UIView = {
                let footerView = UIView()
                footerView.backgroundColor = .init(hex: 0xDBDEE8, alpha: 0.4)
                return footerView
            }()
            return footerView
        }
        return nil
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 1 { return 0 }
        return 6
    }
    
}
