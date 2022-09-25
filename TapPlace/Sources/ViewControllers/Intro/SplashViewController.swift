//
//  SplashViewController.swift
//  TapPlace
//
//  Created by 박상현 on 2022/08/05.
//

import UIKit

class SplashViewController: UIViewController {
    /**
     * 로직 변경...
     * 처음에 서버에 요청할 정보가 무엇이 있는가?
     * 1. 약관정보, 유저 존재 여부,
     * -------------
     * 1. 서버 연동 확인
     * 1-1. true -> 유저정보 확인, false -> 앱종료
     * 2. 유저 정보가 등록 되어 있는지 확인
     * 2-1. true -> 약관 동의 확인, false -> 온보딩
     * 3.동의 한 약관이 최신인가?
     * 3-1. true -> 결제수단 등록 여부 확인, false -> 동의가 필요한 약관 뷰 열어주기
     * 4. 결제수단 등록이 되어 있는가?
     * 4-1. true -> 메인으로 이동, false -> 결제수단 성정 뷰 열어주기
     */
    
    var isServerStatus: Bool = false
    var isExistsUser: Bool = false
    var isAgreeLatestService: Bool = false
    var isAgreeLatestPersonal: Bool = false
    
    
    var storageViewModel = StorageViewModel()
    var userViewModel = UserViewModel()
    var bookmarkViewModel = BookmarkViewModel()
    let currentStatusLabel = UILabel()
    //MARK: - ViewController Lift Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        checkUUID()
        setupView()
        //userInfoSetting()
        print("*** TAPPLACE API URL: \(Constants.tapplaceApiUrl)")
        print("*** USER UUID: \(Constants.keyChainDeviceID)")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        var nextVC: UIViewController?
        
        
        loadLatestTerms { result in
            switch result {
            case false:
                self.exitApp()
            case true:
                self.checkExistsUser { result in
                    self.checkedServer()
                }
            }
        }        
    }
}
//MARK: - Logic Functions
extension SplashViewController {
    /**
     * @ 서버 연동 실패시 알림읠 띄우고 앱을 종료시킴
     * coder : sanghyeon
     */
    func exitApp() {
        showToast(message: "서버와의 연동에 실패했습니다.\n잠시 후 앱을 종료합니다.", view: self.view)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            UIApplication.shared.perform(#selector(NSXPCConnection.suspend))
            exit(0)
        }
    }
    /**
     * @ 최신 약관 정보 불러오기
     * coder : sanghyeon
     */
    func loadLatestTerms(completion: @escaping (Bool) -> ()) {
        userViewModel.requestLatestTerms { result, error in
            if let _ = error {
                self.isServerStatus = false
                completion(false)
            }
            if let result = result {
                self.isServerStatus = true
                LatestTermsModel.latestServiceDate = result.serviceDate.stringValue ?? ""
                LatestTermsModel.latestPersonalDate = result.personalDate.stringValue ?? ""
                completion(true)
            }
        }
    }
    /**
     * @ 서버에 유저 정보가 있는가?
     * coder : sanghyeon
     */
    func checkExistsUser(completion: @escaping (Bool) -> ()) {
        self.userViewModel.requestLatestTerms(checkOnly: false) { result, error in
            print("*********** \(result)")
            if let _ = error {
                self.isExistsUser = false
                completion(false)
            }
            if let result = result {
                self.isExistsUser = true
                let userServiceDate = result.serviceDate.stringValue ?? ""
                let userPersonalDate = result.personalDate.stringValue ?? ""
                self.isAgreeLatestService = Bool(userServiceDate.toBoolean)
                self.isAgreeLatestPersonal = Bool(userPersonalDate.toBoolean)
                completion(true)
            }
        }
    }
    /**
     * @ 서버 확인이 끝나고 각 조건에 맞게 유저를 이동시키자
     * coder : sanghyeon
     *
     *
     *
     * 1. 서버 연동 확인
     * 1-1. true -> 유저정보 확인, false -> 앱종료
     * 2. 유저 정보가 등록 되어 있는지 확인
     * 2-1. true -> 약관 동의 확인, false -> 온보딩
     * 3.동의 한 약관이 최신인가?
     * 3-1. true -> 결제수단 등록 여부 확인, false -> 동의가 필요한 약관 뷰 열어주기
     * 4. 결제수단 등록이 되어 있는가?
     * 4-1. true -> 메인으로 이동, false -> 결제수단 성정 뷰 열어주기
     *
     */
    func checkedServer() {
        /// 한 번 더 서버 상태를 확인 해보자
        if !isServerStatus { exitApp() }
        /// 유저 정보가 있는가?
        print("isExistsUser: \(isExistsUser)")
        switch isExistsUser {
        case true:
            /// 북마크 정보를 다 가져오고서 동의 한 약관들을 살펴보자
            let termsVC = TermsWebViewViewController()
            termsVC.isExistUser = isExistsUser
            switch checkUserTermsStatus() {
            case .service:
                termsVC.term = TermsModel.lists.first(where: {$0.title == "서비스 이용약관"})
                moveViewController(termsVC, present: false)
            case .privacy:
                termsVC.term = TermsModel.lists.first(where: {$0.title == "개인정보 수집 및 이용동의"})
                moveViewController(termsVC, present: false)
            case .success:
                switch isPickedPayments() {
                case true:
                    moveViewController(TabBarViewController(), present: true)
                case false:
                    moveViewController(PickPaymentsViewController(), present: false)
                }
            case .fail:
                showToast(message: "예기치 못한 오류가 발생하였습니다.\n잠시 후, 다시 시도 해주식 바랍니다.", view: self.view)
                break
            }
            

        case false:
            UserRegisterModel.setUser.os = "ios"
            UserRegisterModel.setUser.userID = Constants.keyChainDeviceID
            UserRegisterModel.setUser.marketingAgree = false
            moveViewController(OnBoardingViewController(), present: false)
            break
        }
    }
    /**
     * @ 유저가 동의 한 약관을 확인
     * coder : sanghyeon
     */
    func checkUserTermsStatus() -> TermResultType {
        if !isAgreeLatestService {
            return .service
        }
        if !isAgreeLatestPersonal {
            return .privacy
        }
        if isAgreeLatestService && isAgreeLatestPersonal {
            return .success
        }
        return .fail
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    /**
     * @ 유저가 동의한 약관과 최신 약관 비교
     * coder : sanghyeon
     */
//    func checkTerms() -> TermResultType {
//        currentStatusLabel.text = "새로운 약관 정보를 불러오는중..."
//        if let user = storageViewModel.getUserInfo(uuid: Constants.keyChainDeviceID) {
//            //            print("유저의 서비스 이용약관 날짜: \(user.agreeTerm), 유저의 개인정보 처리방침 날짜: \(user.agreePrivacy)")
//            //            print("최신 이용약관 날짜: \(LatestTermsModel.latestServiceDate), 최신 개인정보 처리방침 날짜: \(LatestTermsModel.latestPersonalDate)")
//            if user.agreeTerm != LatestTermsModel.latestServiceDate {
//                //                print("서비스 이용약관 날짜 다름")
//                return .service
//            } else if user.agreePrivacy != LatestTermsModel.latestPersonalDate {
//                //                print("서비스 개인정보 처리방침 날짜 다름")
//                return .privacy
//            } else {
//                return .success
//            }
//        }
//        return .fail
//    }
    /**
     * @ 유저 UUID 체크
     * coder : sanghyeon
     */
    private func checkUUID() {
        currentStatusLabel.text = "유저 정보 확인중..."
        if let _ = KeyChain.readUserDeviceUUID() {} else {
            KeyChain.saveUserDeviceUUID(Constants.keyChainDeviceID)
        }
    }
    /**
     * @ 초기 레이아웃 설정
     * coder : sanghyeon
     */
    private func setupView() {
        /// 뷰컨트롤러 배경색 지정
        view.backgroundColor = .white
        self.navigationController?.navigationBar.isHidden = true
        
        let logoImageView: UIImageView = {
            let logoImageView = UIImageView()
            logoImageView.image = .init(named: "fullLogo")
            logoImageView.contentMode = .scaleAspectFit
            return logoImageView
        }()
        currentStatusLabel.sizeToFit()
        currentStatusLabel.textColor = .init(hex: 0x9E9E9E)
        currentStatusLabel.font = .systemFont(ofSize: CommonUtils.resizeFontSize(size: 14), weight: .regular)
        
        
        view.addSubview(logoImageView)
        view.addSubview(currentStatusLabel)
        
        logoImageView.snp.makeConstraints {
            $0.center.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(50)
        }
        currentStatusLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-10)
        }
    }
    /**
     * @ 초기 실행 여부 확인
     * return : 확인 여부 (Bool)
     * coder : sanghyeon
     */
    private func isFirstLaunch() -> Bool {
        currentStatusLabel.text = "첫 실행 여부 확인중..."
        guard let user = storageViewModel.getUserInfo(uuid: Constants.keyChainDeviceID) else { return true }
        if user.isFirstLaunch {
            return true
        } else {
            return false
        }
        
    }
    /**
     * @ 약관 동의가 되었는지 확인
     * coder : sanghyeon
     */
//    private func isAgreeTerms() -> Bool {
//        currentStatusLabel.text = "약관 동의 여부 확인중..."
//        let user = storageViewModel.getUserInfo(uuid: Constants.keyChainDeviceID)
//        if user?.agreeTerm == "" || user?.agreePrivacy == "" {
//            return false
//        } else {
//            return true
//        }
//    }
    /**
     * @ 성별, 생년월일(유저 정보) 설정 되었는지 확인
     * coder : sanghyeon
     */
//    private func isSettedUser() -> Bool {
//        let user = storageViewModel.getUserInfo(uuid: Constants.keyChainDeviceID)
//        if user?.birth == "" || user?.sex == "" {
//            return false
//        } else {
//            return true
//        }
//    }
    /**
     * @ 관심 결제수단 여부 확인
     * return : 확인 여부 (Bool)
     * coder : sanghyeon
     */
    private func isPickedPayments() -> Bool {
        currentStatusLabel.text = "결제수단 설정 여부 확인중..."
        if storageViewModel.numberOfFavoritePayments > 0 {
            return true
        }
        return false
    }
    /**
     * @ 뷰 이동
     * 자연스러운 이동을 위해 3초의 지연 후 이동합니다.
     * coder : sanghyeon
     */
    private func moveViewController(_ vc: UIViewController, present: Bool) {
        if present {
            vc.modalPresentationStyle = .fullScreen
            vc.modalTransitionStyle = .crossDissolve
            self.present(vc, animated: true)
        } else {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    /**
     * @ 유저 정보 세팅
     * coder : sanghyeon
     */
//    private func userInfoSetting() {
//        currentStatusLabel.text = "유저 정보 설정중..."
//        let isUserInfo = storageViewModel.existUser(uuid: Constants.keyChainDeviceID)
//        if !isUserInfo {
//            let userModel = UserModel(uuid: Constants.keyChainDeviceID, isFirstLaunch: true, agreeTerm: "", agreePrivacy: "", agreeMarketing: "", birth: "", sex: "")
//            storageViewModel.writeUser(userModel)
//        }
//    }
}
