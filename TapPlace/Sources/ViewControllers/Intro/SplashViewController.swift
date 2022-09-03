//
//  SplashViewController.swift
//  TapPlace
//
//  Created by 박상현 on 2022/08/05.
//

import UIKit

class SplashViewController: UIViewController {
    /**
     * 이 주석은 작업 후 삭제 예정
     * 스플래시뷰 로직 계획
     * 1. User Defaults로 초기 실행 확인
     * 1-1. 초기 실행시 온보딩 뷰 로드
     * 1-2. 초기실행 아닐경우 약관 동의 여부 확인
     * 2-1. 약관 동의가 안되었을 경우, 약관동의 뷰 이동
     * 2-2. 약관 동의가 되었을 경우, 결제수단 등록 확인
     * 3-1. 생년월일 등록 안되었을 경우, 생년월일 등록 뷰 이동
     * 3-2. 생년월일 등록 되었을 경우, 메인 뷰컨트롤러 이동
     * 4-1. 결제수단 등록이 안되었을 경우, 결제수단 등록 뷰 이동
     * 4-2. 결제수단 등록이 되었을 경우 성별 및 생년월일 등록 확인
     * * coder : sanghyeon
     */
    var storageViewModel = StorageViewModel()
    //MARK: - ViewController Lift Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        print(userSettingViewModel.dataBases?.location)
        print(Constants.userDeviceID)
        setupView()
        setTestLayout()
        userInfoSetting()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        var nextVC: UIViewController?
        if isFirstLaunch() {
            /// 초기실행일 경우 온보딩 뷰 이동
            print("초기실행!")
            nextVC = OnBoardingViewController()
        } else {
            if isAgreeTerms() {
                print("약관 동의 되었음")
                if isSettedUser() {
                    print("성별, 생년월일 설정 되었음")
                    if isPickedPayments() {
                        print("관심결제수단 설정 되었음")
                        self.navigationController?.navigationBar.isHidden = true
                        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
                        moveViewController(TabBarViewController(), present: true)
                    } else {
                        print("관심결제수단 설정 안됨")
                        nextVC = PickPaymentsViewController()
                    }
                } else {
                    print("성별, 생년월일 설정 안됨")
                    nextVC = PrivacyViewController()
//                    nextVC = StoreDetailViewController()
                }
            } else {
                print("약관 동의 안됨")
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
        /*
        vc.modalTransitionStyle = .flipHorizontal
        vc.modalPresentationStyle = .fullScreen
         */
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
            print("유저정보 없음")
            let userModel = UserModel(uuid: CommonUtils.getDeviceUUID(), isFirstLaunch: true, agreeTerm: "", agreePrivacy: "", agreeMarketing: "", birth: "", sex: "")
            storageViewModel.writeUser(userModel)
        }
    }
}
