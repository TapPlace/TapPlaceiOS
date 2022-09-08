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
        print(storageViewModel.dataBases?.location)
        print(Constants.userDeviceID)
        loadTerms()
        setupView()
        setTestLayout()
        userInfoSetting()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        var nextVC: UIViewController?
        if isFirstLaunch() {
            /// 초기실행일 경우 온보딩 뷰 이동
            nextVC = OnBoardingViewController()
        } else {
            if isAgreeTerms() {
                if isSettedUser() {
                    /// 성별 생년월일 설정 되었음
                    if isPickedPayments() {
                        /// 관심결제수단 설정 되었음
                        self.navigationController?.navigationBar.isHidden = true
                        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
                        lazy var vc = TabBarViewController()
                        //vc.showStoreInfo(storeID: "", isShowNavigation: false)
                        moveViewController(vc, present: true)
                        //                        moveViewController(FeedbackListViewController(), present: true)
                    } else {
                        /// 관심결제수단 설정 안됨
                        nextVC = PickPaymentsViewController()
                    }
                } else {
                    /// 성별, 생년월일 설정 안됨
                    nextVC = PrivacyViewController()
                }
            } else {
                /// 약관 동의 안됨
                nextVC = TermsViewController()
            }
        }
        guard let nextVC = nextVC else { return }
        moveViewController(nextVC, present: false)
    }
}
//MARK: - Logic Functions
extension SplashViewController {
    /**
     * @ 테스트 모드 레이아웃, 작업 완료 후 삭제 요망
     * coder : sanghyeon
     */
    private func setTestLayout() {
        let testLabel: UILabel = {
            let testLabel = UILabel()
            testLabel.text = "SplashVC"
            testLabel.sizeToFit()
            return testLabel
        }()
        view.addSubview(testLabel)
        testLabel.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
        
        let switchButton: UIButton = {
            let switchButton = UIButton()
            switchButton.setTitle("firstLaunch Toggle", for: .normal)
            switchButton.setTitleColor(.blue, for: .normal)
            return switchButton
        }()
        view.addSubview(switchButton)
        switchButton.snp.makeConstraints {
            $0.top.equalTo(testLabel).offset(20)
            $0.width.equalTo(180)
            $0.height.equalTo(40)
            $0.centerX.equalToSuperview()
        }
        switchButton.addTarget(self, action: #selector(firstLaunchToggle), for: .touchUpInside)
    }
    /**
     * @ 작업 완료후 삭제!!!
     * coder : sanghyeon
     */
    @objc func firstLaunchToggle() {
        print("called: firstLaunchToggle()")
        if UserDefaults.contains("firstLaunch") {
            let firstLaunch = UserDefaults.standard.bool(forKey: "firstLaunch")
            if firstLaunch {
                print("firstLaunch will false")
                UserDefaults.standard.set(false, forKey: "firstLaunch")
            } else {
                print("firstLaunch will true")
                UserDefaults.standard.set(true, forKey: "firstLaunch")
            }
        } else {
            print("firstLaunch will false")
            UserDefaults.standard.set(false, forKey: "firstLaunch")
        }
    }
    /**
     * @ 최신 약관 정보 요청
     * coder : sanghyeon
     */
    func loadTerms() {
        userViewModel.requestLatestTerms(uuid: Constants.userDeviceID) { result in
            guard let result = result else { return }
            LatestTermsModel.latestServiceDate = result.serviceDate
            LatestTermsModel.latestPersonalDate = result.personalDate
        }
    }
    /**
     * @ 초기 레이아웃 설정
     * coder : sanghyeon
     */
    private func setupView() {
        /// 뷰컨트롤러 배경색 지정
        view.backgroundColor = .white
    }
    /**
     * @ 초기 실행 여부 확인
     * return : 확인 여부 (Bool)
     * coder : sanghyeon
     */
    private func isFirstLaunch() -> Bool {
        guard let user = storageViewModel.getUserInfo(uuid: CommonUtils.getDeviceUUID()) else { return true }
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
        let user = storageViewModel.getUserInfo(uuid: Constants.userDeviceID)
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
        let user = storageViewModel.getUserInfo(uuid: Constants.userDeviceID)
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
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3)) {
            if present {
                vc.modalPresentationStyle = .fullScreen
                vc.modalTransitionStyle = .crossDissolve
                self.present(vc, animated: true)
            } else {
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    /**
     * @ 유저 정보 세팅
     * coder : sanghyeon
     */
    private func userInfoSetting() {
        let isUserInfo = storageViewModel.existUser(uuid: Constants.userDeviceID)
        if !isUserInfo {
            let userModel = UserModel(uuid: CommonUtils.getDeviceUUID(), isFirstLaunch: true, agreeTerm: "", agreePrivacy: "", agreeMarketing: "", birth: "", sex: "")
            storageViewModel.writeUser(userModel)
        }
    }
}
