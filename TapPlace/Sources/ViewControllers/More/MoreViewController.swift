//
//  MoreViewController.swift
//  TapPlace
//
//  Created by 박상현 on 2022/08/13.
//

import UIKit
import NMapsMap

class MoreViewController: CommonViewController {
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
        
        // 베타 버전 임시 처리
        alarmButton.isHidden = true
        settingButton.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        headerView = MoreHeaderView()
        headerView?.userViewModel = self.userViewModel
        userViewModel.requestUserAllCount()
        tabBar?.hideTabBar(hide: false)
        tableView.reloadData()
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
            break
//            print("네비게이션 설정 버튼 탭")
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
extension MoreViewController: UITableViewDelegate, UITableViewDataSource, MoreHeaderButtonProtocol, MoreHeaderViewProtocol {
    func didTapPaymentsButton() {
        let vc = PickPaymentsViewController()
        vc.isEditMode = true
        tabBar?.hideTabBar(hide: true)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func didTapMoreHeaderItemButton(_ sender: UIButton) {
        guard let headerView = headerView else { return }
        switch sender {
        case headerView.itemBookmark.button:
//            print("즐겨찾기 탭")
            let vc = BookmarkViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        case headerView.itemFeedback.button:
//            print("피드백 탭")
            let vc = FeedbackListViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        case headerView.remainFeedback.button:
            break
//            print("등록가게 탭")
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
                case .version:cell.subTitle = "클로즈베타" // 베타버전 임시 문구
                case .reset:cell.subTitle = Constants.keyChainDeviceID // 베타버전 임시 문구
                default: break
                } 
            }
            return cell
        case 1:
            let targetTerm = TermsModel.lists.filter({$0.isTerm == true})
            cell.title = targetTerm[indexPath.row].title
            cell.subTitle = ""
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            guard let cell = tableView.cellForRow(at: indexPath) as? MoreMenuTableViewCell else { return }
            if let vc = menuList[indexPath.row].vc as? InquiryViewController {
                vc.type = menuList[indexPath.row].type
                self.navigationController?.pushViewController(vc, animated: true)
                return
            } else {
                if let vc = menuList[indexPath.row].vc{
                    self.navigationController?.pushViewController(vc, animated: true)
                    return
                }
            }
            
            if let type = cell.menuType {
                switch type {
                case .version:
                    break
                case .reset:
                    showResetActionSheet()
                case .feedback:
                    self.navigationController?.pushViewController(menuList[indexPath.row].vc!, animated: true)
                default: break
                }
            }
        case 1:
            let targetTerm = TermsModel.lists.filter({$0.isTerm == true})
            let vc = TermsWebViewViewController()
            vc.term = targetTerm[indexPath.row]
            vc.isReadOnly = true
            tabBar?.isShowFloatingButton = false
            self.navigationController?.pushViewController(vc, animated: true)
        default: break
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    //MARK: Header & Footer
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            headerView?.delegate = self
            headerView?.itemBookmark.delegate = self
            headerView?.itemFeedback.delegate = self
            headerView?.remainFeedback.delegate = self
            let userPaymentsEncodedString = storageViewModel.userFavoritePaymentsString
            var userPaymentsString: String = ""
            
            for i in 0...userPaymentsEncodedString.count - 1 {
                if let payment = PaymentModel.thisPayment(payment: userPaymentsEncodedString[i]) {
                    if i == userPaymentsEncodedString.count - 1 {
                        userPaymentsString += payment.designation
                    } else {
                        userPaymentsString += payment.designation + ", "
                    }
                }
            }
            
            headerView?.payments = userPaymentsString
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
    
    /**
     * @ 초기화 액션시트 생성
     * coder : sanghyeon
     */
    func showResetActionSheet() {
        let actionSheet = UIAlertController(title: "활동내역 초기화", message: "초기화하신 후 되돌릴 수 없습니다.", preferredStyle: .actionSheet)
        let bookmark = UIAlertAction(title: "즐겨찾기 항목 초기화", style: .default) { action in
            print("*** MoreVC: 즐겨찾기 항목 초기화 탭")
            self.bookmarkViewModel.requestClearBookmark() { result in
                if result {
                    self.headerView?.countOfBookmark = 0
                    self.tableView.reloadData()
                } else {
                    showToast(message: "알 수 없는 이유로 초기화하지 못했습니다.\n잠시 후, 다시 시도해주시기 바랍니다.", view: self.view)
                }
            }
        }

        let clear = UIAlertAction(title: "모든 항목 초기화", style: .destructive) { action in
//            print("모든 항목 초기화 탭")
            let alertAction = UIAlertController(title: "모든 항목 초기화", message: "이 작업은 되돌릴 수 없으며, 앱에 저장된 가맹점 정보 및 서버에 저장된 데이터 모두 삭제합니다.", preferredStyle: .alert)
            let alertConfirm = UIAlertAction(title: "초기화", style: .destructive) { action in
                self.userViewModel.dropUserInfo() { result in
                    self.storageViewModel.deleteAllPayments {}
                    self.storageViewModel.deleteAllSearchHistory()
                    if let deleteResult = result as? Bool {
//                        print("moreVC, dropUserIfo, Success")
                        self.storageViewModel.deleteUser() { result in
                            if deleteResult == true {
                                KeyChain.deleteUserDeviceUUID()
                                DispatchQueue.main.async {
                                    self.dismiss(animated: true)
                                    self.present(SplashViewController(), animated: true)
                                }
                            } else {
                                showToast(message: "알 수 없는 이유로 초기화에 실패했습니다.\n다시 시도해주시기 바랍니다.", view: self.view)
                            }
                        }
                    } else {
                        //                        print("moreVC, dropUserInfo, Error")
                    }
                }
            }
            let alertDismiss = UIAlertAction(title: "취소", style: .default)
            alertAction.addAction(alertConfirm)
            alertAction.addAction(alertDismiss)
            self.present(alertAction, animated: true, completion: nil)
            
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel) { action in
//            print("취소 탭")
        }
        
        actionSheet.addAction(bookmark)
        actionSheet.addAction(clear)
        actionSheet.addAction(cancel)
        
        present(actionSheet, animated: true, completion: nil)
    } //Function: 초기화 액션시트
    
    
}
