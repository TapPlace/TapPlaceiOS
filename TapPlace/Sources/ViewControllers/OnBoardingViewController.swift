//
//  OnBoardingViewController.swift
//  TapPlace
//
//  Created by 박상현 on 2022/08/05.
//

import UIKit
import SnapKit

class OnBoardingViewController: UIViewController {
    /**
     * 이 주석은 작업 후 삭제 예정
     * 온보딩뷰 에서 관심 설정뷰로 이동시 User Defaults 초기실행 값 지정
     * coder : sanghyeon
     */

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setTestLayout()
    }
    

}
//MARK: - Layout
extension OnBoardingViewController {
    /**
     * @ 테스트모드 레이아웃, 추후 작업시 삭제 요망
     * coder : sanghyeon
     */
    private func setTestLayout() {
        let testLabel: UILabel = {
            let testLabel = UILabel()
            testLabel.text = "OnBoardingVC"
            testLabel.sizeToFit()
            return testLabel
        }()
        view.addSubview(testLabel)
        testLabel.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
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
}
