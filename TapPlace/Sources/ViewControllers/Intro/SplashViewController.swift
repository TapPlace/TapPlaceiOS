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
     * 1-2. 초기실행 아닐경우 관심 결제수단 설정 여부 확인
     * 2-1. 관심 결제수단 미 설정시 관심 결제수단 설정 뷰 로드
     * 2-2. 관심 결제수단 설정시 관심 메인 뷰 로드
     * * coder : sanghyeon
     */
    
    //MARK: - ViewController Lift Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setTestLayout()
        print("사용자 디바이스 고유 값:", CommonUtils.getDeviceUUID())
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if isFirstLaunch() {
            /// 초기실행일 경우 온보딩 뷰 이동
            print("초기실행!")
            moveViewController(OnBoardingViewController(), present: false)
        } else {
            if isPickedPayments() {
                /// 관심 결제수단 등록 되어있을 경우 메인 뷰컨트롤러 이동

                moveViewController(TabBarViewController(), present: true)
            } else {
                /// 관심 결제수단 등록 되어있지 않을 경우 관심 결제수단 설정 뷰로 이동
                moveViewController(PickPaymentsViewController(), present: false)
            }
        }
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
        if UserDefaults.contains("firstLaunch") {
            let firstLaunch = UserDefaults.standard.bool(forKey: "firstLaunch")
            print("firstLaunch:", firstLaunch)
            return firstLaunch
        }
        return true
    }
    /**
     * @ 관심 결제수단 여부 확인
     * return : 확인 여부 (Bool)
     * coder : sanghyeon
     */
    private func isPickedPayments() -> Bool {
        let sampleFavoritePayments:[String] = ["D"]
        if sampleFavoritePayments.count > 0 {
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
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
            if present {
                vc.modalPresentationStyle = .fullScreen
                vc.modalTransitionStyle = .crossDissolve
                self.present(vc, animated: true)
            } else {
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
}
