//
//  SettingViewController.swift
//  TapPlace
//
//  Created by 박상현 on 2022/09/27.
//

import UIKit

class SettingViewController: CommonViewController {

    let customNavigationBar = CustomNavigationBar()
    let settingTableView = UITableView()
    var settingDataSource: [Int: [String]] = [:]
    var userInfo: UserInfoResponseModel?
    let alarmSwitch: UISwitch = UISwitch()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupNavigation()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBar?.hideTabBar(hide: true)
        loadUserInfo()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
}

//MARK: - Layout
extension SettingViewController: CustomNavigationBarProtocol {
    func didTapLeftButton() {
        self.navigationController?.popViewController(animated: true)
    }
    
    /**
     * @ 유저 정보 불러오기
     * coder : sanghyeon
     */
    func loadUserInfo() {
        UserDataService().requestFetchUserInfo(userID: Constants.keyChainDeviceID) { result in
            if let result = result {
                self.userInfo = result
            }
            self.settingTableView.reloadData()
        }
    }
    /**
     * @ 초기 레이아웃 설정
     * coder : sanghyeon
     */
    func setupView() {
        //MARK: ViewDefine
        let safeArea = view.safeAreaLayoutGuide
        
        
        //MARK: ViewPropertyManual
        view.backgroundColor = .white
        settingTableView.separatorStyle = .none
        settingTableView.isScrollEnabled = false

        
        //MARK: AddSubView
        view.addSubview(customNavigationBar)
        view.addSubview(settingTableView)
        
        
        //MARK: ViewContraints
        customNavigationBar.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(customNavigationBar.containerView)
        }
        settingTableView.snp.makeConstraints {
            $0.top.equalTo(customNavigationBar.snp.bottom).offset(10)
            $0.leading.trailing.bottom.equalTo(safeArea)
        }
        
        
        //MARK: ViewAddTarget
        customNavigationBar.delegate = self
        settingTableView.register(MoreMenuTableViewCell.self, forCellReuseIdentifier: MoreMenuTableViewCell.cellId)
        
        
        //MARK: Delegate
        settingTableView.delegate = self
        settingTableView.dataSource = self
    }
    /**
     * @ 네비게이션 설정
     * coder : sanghyeon
     */
    func setupNavigation() {
        customNavigationBar.titleText = "설정"
        customNavigationBar.isUseLeftButton = true
    }
}

//MARK: - TableView
extension SettingViewController: UITableViewDelegate, UITableViewDataSource {
    /**
     * @ 테이블뷰 메뉴 설정
     * coder : sanghyeon
     */
    func setupTableView() {
        /// 메뉴 설정
        settingDataSource = [
            0: ["정보 수정", "결제수단 설정", "알림 수신"],
            1: ["활동내역 초기화"]
        ]
        settingTableView.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return settingDataSource.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingDataSource[section]?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = setupCell(indexPath: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didTapCell(indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    /**
     * @ 셀 설정
     * coder : sanghyeon
     */
    func setupCell(indexPath: IndexPath) -> UITableViewCell {
        guard let cell = settingTableView.dequeueReusableCell(withIdentifier: MoreMenuTableViewCell.cellId, for: indexPath) as? MoreMenuTableViewCell else { return UITableViewCell() }
    
        let cellTitle = settingDataSource[indexPath.section]![indexPath.row]

        switch cellTitle {
        case "정보 수정":
            if let userInfo = userInfo {
                cell.subTitle = "\(userInfo.birth) / \(userInfo.sex)성"
            } else {
                cell.subTitle = "알 수 없음"
            }
        case "알림 수신":
            cell.addSubview(alarmSwitch)
            alarmSwitch.snp.makeConstraints {
                $0.centerY.equalTo(cell)
                $0.trailing.equalTo(cell).offset(-20)
            }
            alarmSwitch.isOn = storageViewModel.getAlarm()
            alarmSwitch.addTarget(self, action: #selector(didToggleSwitch(_:)), for: .touchUpInside)

        default: break
        }

        cell.title = cellTitle
        cell.selectionStyle = .none
        return cell
    }
    
    /**
     * @ 셀 클릭 이벤트
     * coder : sanghyeon
     */
    func didTapCell(indexPath: IndexPath) {
        let cellTitle = settingDataSource[indexPath.section]![indexPath.row]
        switch cellTitle {
        case "정보 수정":
            let vc = PrivacyViewController()
            vc.isEditMode = true
            vc.userInfo = userInfo
            self.navigationController?.pushViewController(vc, animated: true)
        case "결제수단 설정":
            let vc = PickPaymentsViewController()
            vc.isEditMode = true
            self.navigationController?.pushViewController(vc, animated: true)
        case "알림 수신":
            print("*** SettingVC, \(cellTitle) 탭")
        case "활동내역 초기화" :
            showResetActionSheet()
        default: break
        }
    }
    
    //MARK: FooterView
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section != 0 { return nil }
        let footerView = UIView()
        footerView.backgroundColor = .init(hex: 0xDBDEE8, alpha: 0.4)
        return footerView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section != 0 { return .zero }
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
                if !result {
                    showToast(message: "알 수 없는 이유로 초기화하지 못했습니다.\n잠시 후, 다시 시도해주시기 바랍니다.", view: self.view)
                }
            }
        }

        let clear = UIAlertAction(title: "모든 항목 초기화", style: .destructive) { action in
            let alertAction = UIAlertController(title: "모든 항목 초기화", message: "이 작업은 되돌릴 수 없으며, 앱에 저장된 가맹점 정보 및 서버에 저장된 데이터 모두 삭제합니다.", preferredStyle: .alert)
            let alertConfirm = UIAlertAction(title: "초기화", style: .destructive) { action in
                self.userViewModel.dropUserInfo() { result in
                    self.storageViewModel.deleteAllPayments {}
                    self.storageViewModel.deleteAllSearchHistory()
                    if let deleteResult = result as? Bool {
                        self.storageViewModel.deleteUser() { result in
                            if deleteResult == true {
                                print("유저 정보가 다 지워졌어요")
                                KeyChain.deleteUserDeviceUUID()
                                showToast(message: "초기화가 완료 되었습니다.\n잠시 후 앱이 종료됩니다.", view: self.view)
                                DispatchQueue.main.asyncAfter(deadline: .now()+2) {
                                    exit(0)
                                }
                            } else {
                                showToast(message: "알 수 없는 이유로 초기화에 실패했습니다.\n다시 시도해주시기 바랍니다.", view: self.view)
                            }
                        }
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
    
    /**
     * @ 알림 설정 스위치 토글 이벤트
     * coder : sanghyeon
     */
    @objc func didToggleSwitch(_ sender: UISwitch) {
        authorization.requestNotificationAuthorization() { _ in
            DispatchQueue.main.async {
                /// 유저의 설정 값에 따라 서버로 보내는 값 설정
                var token: String = ""
                self.fcm.generateFCMToken() { result in
                    if let result = result {
                        token = "\(result)"
                        sender.isOn = self.storageViewModel.toggleAlarm(fcmToken: token)
                    }
                }
//                switch sender.isOn {
//                case true:
//                    self.fcm.generateFCMToken() { result in
//                        if let result = result {
//                            token = "\(result)"
//                            sender.isOn = self.storageViewModel.toggleAlarm(fcmToken: token)
////                            let parameter: [String: Any] = [
////                                "user_id": "\(Constants.keyChainDeviceID)",
////                                "token": "\(token)"
////                            ]
////                            print("par: \(parameter)")
////                            UserDataService().requestFetchUpdateUser(parameter: parameter, header: Constants().header) { response in
////                                if response {
////                                    sender.isOn = self.storageViewModel.toggleAlarm()
////                                } else {
////                                    showToast(message: "알 수 없는 이유로 서버로 토큰이 전송되지 않았습니다.\n알림이 정상적으로 수신되지 않을 수 있습니다.", view: self.view)
////                                }
////                            }
//                        }
//                    }
//                case false:
//                    token = ""
//                    let parameter: [String: Any] = [
//                        "user_id": "\(Constants.keyChainDeviceID)",
//                        "token": "\(token)"
//                    ]
//                    print("par: \(parameter)")
//                    UserDataService().requestFetchUpdateUser(parameter: parameter, header: Constants().header) { response in
//                        if response {
//                            sender.isOn = self.storageViewModel.toggleAlarm()
//                        } else {
//                            showToast(message: "알 수 없는 이유로 설정되지 않았습니다.\n지속적인 문제 발생시 관리자에게 문의하세요.", view: self.view)
//                        }
//                    }
//                }
            }
        }
    }
    
}
