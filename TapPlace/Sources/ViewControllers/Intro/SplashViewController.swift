//
//  SplashViewController.swift
//  TapPlace
//
//  Created by 박상현 on 2022/08/05.
//

import UIKit

class SplashViewController: UIViewController {
    var storageViewModel = StorageViewModel()
    var userViewModel = UserViewModel()
    //MARK: - ViewController Lift Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        checkUUID()
        setupView()
        userInfoSetting()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        var nextVC: UIViewController?
        userViewModel.requestLatestTerms(uuid: Constants.keyChainDeviceID) { result in
            if let result = result {
                LatestTermsModel.latestServiceDate = result.serviceDate
                LatestTermsModel.latestPersonalDate = result.personalDate
                
                switch self.isFirstLaunch() { /// 초기실행 검증
                case true:
                    nextVC = OnBoardingViewController()
                case false: /// 초기실행 검증 실패
                    switch self.isAgreeTerms() { /// 약관 동의여부 검증
                    case true:
                        switch self.isPickedPayments() { /// 관심결제수단 설정 여부 검증
                        case true:
                            self.navigationController?.navigationBar.isHidden = true
                            self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [self] in
                                switch checkTerms() {
                                case .success:
                                    lazy var vc = TabBarViewController()
                                    //vc.showStoreInfo(storeID: "", isShowNavigation: false)
                                    moveViewController(vc, present: true)
                                default:
                                    let vc = TermsWebViewViewController()
                                    switch checkTerms() {
                                    case .service:
                                        vc.term = TermsModel.lists.first(where: {$0.title == "서비스 이용약관"})
                                        self.navigationController?.pushViewController(vc, animated: true)
                                    case .privacy:
                                        vc.term = TermsModel.lists.first(where: {$0.title == "개인정보 수집 및 이용동의"})
                                        self.navigationController?.pushViewController(vc, animated: true)
                                    default: showToast(message: "예기치 못한 오류가 발생했습니다.\n앱을 껐다가 다시 시도해주세요.", view: self.view)
                                    }
                                }
                            }
                        case false: /// 관심결제수단 설정 여부 검증 실패
                            nextVC = PickPaymentsViewController()
                        }
                    case false: /// 약관 동의여부 검증 실패
                        nextVC = TermsViewController()
                    }
                }
                
                guard let nextVC = nextVC else { return }
                self.moveViewController(nextVC, present: false)
            } else {
                showToast(message: "서버와의 연동에 실패했습니다.\n잠시 후 앱을 종료합니다.", view: self.view)
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    UIApplication.shared.perform(#selector(NSXPCConnection.suspend))
                    exit(0)
                }
            }
        }
    }
}
//MARK: - Logic Functions
extension SplashViewController {
    /**
     * @ 유저가 동의한 약관과 최신 약관 비교
     * coder : sanghyeon
     */
    func checkTerms() -> TermResultType {
        if let user = storageViewModel.getUserInfo(uuid: Constants.keyChainDeviceID) {
            //            print("유저의 서비스 이용약관 날짜: \(user.agreeTerm), 유저의 개인정보 처리방침 날짜: \(user.agreePrivacy)")
            //            print("최신 이용약관 날짜: \(LatestTermsModel.latestServiceDate), 최신 개인정보 처리방침 날짜: \(LatestTermsModel.latestPersonalDate)")
            if user.agreeTerm != LatestTermsModel.latestServiceDate {
                //                print("서비스 이용약관 날짜 다름")
                return .service
            } else if user.agreePrivacy != LatestTermsModel.latestPersonalDate {
                //                print("서비스 개인정보 처리방침 날짜 다름")
                return .privacy
            } else {
                return .success
            }
        }
        return .fail
    }
    /**
     * @ 유저 UUID 체크
     * coder : sanghyeon
     */
    private func checkUUID() {
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
        
        view.addSubview(logoImageView)
        
        logoImageView.snp.makeConstraints {
            $0.center.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(50)
        }
    }
    /**
     * @ 초기 실행 여부 확인
     * return : 확인 여부 (Bool)
     * coder : sanghyeon
     */
    private func isFirstLaunch() -> Bool {
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
    private func isAgreeTerms() -> Bool {
        let user = storageViewModel.getUserInfo(uuid: Constants.keyChainDeviceID)
        if user?.agreeTerm == "" || user?.agreePrivacy == "" {
            return false
        } else {
            return true
        }
    }
    /**
     * @ 성별, 생년월일(유저 정보) 설정 되었는지 확인
     * coder : sanghyeon
     */
    private func isSettedUser() -> Bool {
        let user = storageViewModel.getUserInfo(uuid: Constants.keyChainDeviceID)
        if user?.birth == "" || user?.sex == "" {
            return false
        } else {
            return true
        }
    }
    /**
     * @ 관심 결제수단 여부 확인
     * return : 확인 여부 (Bool)
     * coder : sanghyeon
     */
    private func isPickedPayments() -> Bool {
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
    private func userInfoSetting() {
        let isUserInfo = storageViewModel.existUser(uuid: Constants.keyChainDeviceID)
        if !isUserInfo {
            let userModel = UserModel(uuid: Constants.keyChainDeviceID, isFirstLaunch: true, agreeTerm: "", agreePrivacy: "", agreeMarketing: "", birth: "", sex: "")
            storageViewModel.writeUser(userModel)
        }
    }
}
