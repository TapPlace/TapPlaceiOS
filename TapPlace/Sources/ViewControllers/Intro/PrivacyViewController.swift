//
//  PrivacyViewController.swift
//  TapPlace
//
//  Created by 이상준 on 2022/08/24.
//

import Foundation
import UIKit

class PrivacyViewController: UIViewController {
    
    let navigationBar = NavigationBar()
    let bottomButton = BottomButton()
    let maleButton = UIButton() // 남성 버튼
    let femaleButton = UIButton() // 여성 버튼
    
    override func viewDidLoad() {
        setupView()
        setLayout()
        navigationBar.delegate = self
        bottomButton.delegate = self
    }
}

extension PrivacyViewController {
    
    private func setupView() {
        self.view.backgroundColor = .white
        self.navigationController?.navigationBar.isHidden = true
        /// 네비게이션 컨트롤러 스와이프 뒤로가기 제거
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    private func setLayout() {
        
        let safeArea = view.safeAreaLayoutGuide
        
        let topLabel: UILabel = {
            let topLabel = UILabel()
            topLabel.sizeToFit()
            topLabel.numberOfLines = 2
            topLabel.text = "생년월일과 성별을\n입력해주세요."
            topLabel.textColor = .init(hex: 0x4D4D4D)
            topLabel.font = .boldSystemFont(ofSize: CommonUtils.resizeFontSize(size: 23))
            return topLabel
        }()
        
        let bottomLabel: UILabel = {
            let bottomLabel = UILabel()
            bottomLabel.sizeToFit()
            bottomLabel.numberOfLines = 2
            bottomLabel.text = "(임시작성) 생년월일과 성별은 OO에 활용되며\n가입 후 ‘더보기 > 설정 > 정보수정’에서 변경할 수 있어요."
            bottomLabel.textColor = .init(hex: 0x707070)
            bottomLabel.font = .systemFont(ofSize: CommonUtils.resizeFontSize(size: 15))
            return bottomLabel
        }()
        
        let birthLabel: UILabel = {
            let birthLabel = UILabel()
            birthLabel.sizeToFit()
            birthLabel.text = "생년월일"
            birthLabel.textColor = .init(hex: 0x333333)
            birthLabel.font = .boldSystemFont(ofSize: CommonUtils.resizeFontSize(size: 17))
            return birthLabel
        }()
        
        let birthInputField: UITextField = {
            let birthInputField = UITextField()
            birthInputField.placeholder = "8자리 입력"
            birthInputField.font = .systemFont(ofSize: CommonUtils.resizeFontSize(size: 15))
            return birthInputField
        }()
        
        // 선
        let lineView: UIView = {
            let lineView = UIView()
            lineView.backgroundColor = .init(hex: 0xDBDEE8)
            return lineView
        }()
        
        let genderLabel: UILabel = {
            let genderLabel = UILabel()
            genderLabel.sizeToFit()
            genderLabel.text = "성별"
            genderLabel.textColor = .init(hex: 0x333333)
            genderLabel.font = .boldSystemFont(ofSize: CommonUtils.resizeFontSize(size: 17))
            return genderLabel
        }()
        
        maleButton.backgroundColor = UIColor(red: 0.306, green: 0.467, blue: 0.984, alpha: 0.06)
        maleButton.layer.cornerRadius = 8
        maleButton.layer.borderWidth = 1.5
        maleButton.layer.borderColor = UIColor(red: 0.306, green: 0.467, blue: 0.984, alpha: 0.6).cgColor
        maleButton.setTitle("남성", for: .normal)
        maleButton.setTitleColor(.pointBlue, for: .normal)
        maleButton.titleLabel?.font = .systemFont(ofSize: CommonUtils.resizeFontSize(size: 15))
        maleButton.addTarget(self, action: #selector(self.actionGenderButton(_:)), for: .touchUpInside)
        
        
        femaleButton.layer.cornerRadius = 8
        femaleButton.layer.borderWidth = 1
        femaleButton.layer.borderColor = UIColor(red: 0.859, green: 0.871, blue: 0.91, alpha: 1).cgColor
        femaleButton.setTitle("여성", for: .normal)
        femaleButton.setTitleColor(UIColor(red: 0.62, green: 0.62, blue: 0.62, alpha: 1), for: .normal)
        femaleButton.titleLabel?.font = .systemFont(ofSize: CommonUtils.resizeFontSize(size: 15))
        femaleButton.addTarget(self, action: #selector(self.actionGenderButton(_:)), for: .touchUpInside)
        
        let stackView: UIStackView = {
            let stackView = UIStackView(arrangedSubviews: [maleButton, femaleButton])
            stackView.translatesAutoresizingMaskIntoConstraints = false
            stackView.backgroundColor = .white
            stackView.distribution = .fillEqually
            stackView.setCustomSpacing(13, after: maleButton)
            return stackView
        }()
        
        bottomButton.backgroundColor = .pointBlue
        bottomButton.setTitle("확인", for: .normal)
        bottomButton.setTitleColor(.init(hex: 0xFFFFFF), for: .normal)
        
        view.addSubview(navigationBar)
        navigationBar.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(safeArea)
            $0.width.equalTo(self.view.frame.width)
            $0.height.equalTo(50)
        }
        
        view.addSubview(topLabel)
        topLabel.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom).offset(60)
            $0.leading.equalTo(safeArea).offset(20)
        }
        
        view.addSubview(bottomLabel)
        bottomLabel.snp.makeConstraints {
            $0.top.equalTo(topLabel.snp.bottom).offset(16)
            $0.leading.equalTo(safeArea).offset(20)
        }
        
        view.addSubview(birthLabel)
        birthLabel.snp.makeConstraints {
            $0.top.equalTo(bottomLabel.snp.bottom).offset(44)
            $0.leading.equalTo(safeArea).offset(20)
        }
        
        view.addSubview(birthInputField)
        birthInputField.snp.makeConstraints {
            $0.top.equalTo(birthLabel.snp.bottom).offset(16)
            $0.leading.equalTo(safeArea).offset(20)
            $0.width.equalTo(67)
            $0.height.equalTo(21)
        }
        
        view.addSubview(lineView)
        lineView.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.top.equalTo(birthInputField.snp.bottom).offset(8)
            $0.leading.equalTo(safeArea).offset(20)
            $0.trailing.equalTo(safeArea).offset(-20)
        }
        
        view.addSubview(genderLabel)
        genderLabel.snp.makeConstraints {
            $0.top.equalTo(lineView.snp.bottom).offset(32)
            $0.leading.equalTo(safeArea).offset(20)
        }
        
        view.addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.top.equalTo(genderLabel.snp.bottom).offset(12)
            $0.leading.equalTo(safeArea).offset(20)
            $0.trailing.equalTo(safeArea).offset(-20)
            $0.height.equalTo(48)
        }
        
        view.addSubview(bottomButton)
        bottomButton.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-60)
        }
    }
    
    // 성별 버튼 클릭시 이벤트
    @objc func actionGenderButton(_ sender: UIButton) {
        if sender == maleButton {
            maleButton.backgroundColor = UIColor(red: 0.306, green: 0.467, blue: 0.984, alpha: 0.06)
            maleButton.layer.borderColor = UIColor(red: 0.306, green: 0.467, blue: 0.984, alpha: 0.6).cgColor
            maleButton.layer.borderWidth = 1.5
            maleButton.setTitleColor(.pointBlue, for: .normal)
            
            femaleButton.backgroundColor = .white
            femaleButton.layer.borderWidth = 1.0
            femaleButton.layer.borderColor = UIColor(red: 0.859, green: 0.871, blue: 0.91, alpha: 1).cgColor
            femaleButton.setTitleColor(UIColor(red: 0.62, green: 0.62, blue: 0.62, alpha: 1), for: .normal)
        } else {
            femaleButton.backgroundColor = UIColor(red: 0.306, green: 0.467, blue: 0.984, alpha: 0.06)
            femaleButton.layer.borderColor = UIColor(red: 0.306, green: 0.467, blue: 0.984, alpha: 0.6).cgColor
            femaleButton.layer.borderWidth = 1.5
            femaleButton.setTitleColor(.pointBlue, for: .normal)
            
            maleButton.backgroundColor = .white
            maleButton.layer.borderWidth = 1.0
            maleButton.layer.borderColor = UIColor(red: 0.859, green: 0.871, blue: 0.91, alpha: 1).cgColor
            maleButton.setTitleColor(UIColor(red: 0.62, green: 0.62, blue: 0.62, alpha: 1), for: .normal)
        }
    }
}

// MARK: - 상단 네비게이션 바 Back 버튼 프로토콜 구현
extension PrivacyViewController: BackButtonProtocol {
    func popViewVC() {
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: - 생년월일 텍스트 필드에 대한 프로토콜 구현
extension PrivacyViewController: UITextFieldDelegate {
    
}


extension PrivacyViewController: BottomButtonProtocol {
    func didTapBottomButton() {
        print("눌림")
    }
}
