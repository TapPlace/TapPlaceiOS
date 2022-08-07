//
//  MainViewController.swift
//  TapPlace
//
//  Created by 박상현 on 2022/08/05.
//

import UIKit

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setTestLayout()

        // Do any additional setup after loading the view.
    }
    
}
//MARK: - Layout
extension MainViewController {
    /**
     * @ 테스트모드 레이아웃, 추후 작업시 삭제 요망
     * coder : sanghyeon
     */
    private func setTestLayout() {
        let testLabel: UILabel = {
            let testLabel = UILabel()
            testLabel.text = "MainVC"
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
