//
//  PrivacyViewController.swift
//  TapPlace
//
//  Created by 이상준 on 2022/08/24.
//

import Foundation
import UIKit

class PrivacyViewController: UIViewController {
    
    var isEditMode = false {
        willSet {
            skipButton.isHidden = newValue
        }
    }
    let customNavigationBar = CustomNavigationBar()
    let bottomButton = BottomButton()
    let birthInputField = UITextField() // 생년월일 입력 필드
    let maleButton = UIButton() // 남성 버튼
    let femaleButton = UIButton() // 여성 버튼
    let skipButton = UIButton(type: .system)
    
    var userSex = "남"
    var storageViewModel = StorageViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setLayout()
        
        customNavigationBar.delegate = self
        customNavigationBar.isDrawShadow = false
        customNavigationBar.isDrawBottomLine = false
        customNavigationBar.titleText = ""
        customNavigationBar.isUseLeftButton = true
        
        bottomButton.delegate = self
        
        birthInputField.delegate = self
        birthInputField.keyboardType = .numberPad
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
        

        skipButton.setTitle("건너뛰기", for: .normal)
        skipButton.setTitleColor(.black.withAlphaComponent(0.5), for: .normal)
        skipButton.titleLabel?.font = .systemFont(ofSize: CommonUtils.resizeFontSize(size: 15), weight: .medium)
        skipButton.addTarget(self, action: #selector(didTapSkipButton), for: .touchUpInside)
        
        let topLabel: UILabel = {
            let topLabel = UILabel()
            topLabel.sizeToFit()
            topLabel.numberOfLines = 2
            topLabel.text = "생년월일과 성별을\n입력해주세요."
            topLabel.lineHeight(height: 7)
            topLabel.textColor = .init(hex: 0x4D4D4D)
            topLabel.font = .boldSystemFont(ofSize: CommonUtils.resizeFontSize(size: 23))
            return topLabel
        }()
        
        let bottomLabel: UILabel = {
            let bottomLabel = UILabel()
            bottomLabel.sizeToFit()
            bottomLabel.numberOfLines = 2
            bottomLabel.text = "생년월일과 성별은 맞춤형 광고 제공에 활용되며\n더보기 > 설정에서 변경하실 수 있어요."
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
        
        birthInputField.placeholder = "8자리 입력"
        birthInputField.font = .systemFont(ofSize: CommonUtils.resizeFontSize(size: 15))
        
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

        bottomButton.setButtonStyle(title: "확인", type: .activate, fill: true)
        
        view.addSubview(customNavigationBar)
        customNavigationBar.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(customNavigationBar.containerView)
        }
        
        customNavigationBar.addSubview(skipButton)
        skipButton.snp.makeConstraints {
            $0.trailing.equalTo(safeArea).offset(-20)
            $0.bottom.equalTo(customNavigationBar.containerView).offset(-15)
        }
        
        view.addSubview(topLabel)
        topLabel.snp.makeConstraints {
            $0.top.equalTo(customNavigationBar.snp.bottom).offset(60)
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
            $0.width.equalTo(300)
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
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-50)
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
            
            userSex = "남"
        } else {
            femaleButton.backgroundColor = UIColor(red: 0.306, green: 0.467, blue: 0.984, alpha: 0.06)
            femaleButton.layer.borderColor = UIColor(red: 0.306, green: 0.467, blue: 0.984, alpha: 0.6).cgColor
            femaleButton.layer.borderWidth = 1.5
            femaleButton.setTitleColor(.pointBlue, for: .normal)
            
            maleButton.backgroundColor = .white
            maleButton.layer.borderWidth = 1.0
            maleButton.layer.borderColor = UIColor(red: 0.859, green: 0.871, blue: 0.91, alpha: 1).cgColor
            maleButton.setTitleColor(UIColor(red: 0.62, green: 0.62, blue: 0.62, alpha: 1), for: .normal)
            
            userSex = "여"
        }
    }
}

// MARK: - 상단 네비게이션 바 Back 버튼 프로토콜 구현
extension PrivacyViewController: CustomNavigationBarProtocol {
    func didTapLeftButton() {
        self.navigationController?.popViewController(animated: true)
    }
    @objc func didTapSkipButton() {
        let vc = PickPaymentsViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - 생년월일 텍스트 필드에 대한 프로토콜 구현
extension PrivacyViewController: UITextFieldDelegate {
    // 생년월일 입력필드 8자리 제한
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let textFieldText = textField.text,
              let rangeOfTextToReplace = Range(range, in: textFieldText) else {
            return false
        }
        let substringToReplace = textFieldText[rangeOfTextToReplace]
        let count = textFieldText.count - substringToReplace.count + string.count
        
        if count == 8 {
            DispatchQueue.main.async {
                textField.resignFirstResponder()
            }
        }
        
        return count <= 8
    }
}


extension PrivacyViewController: BottomButtonProtocol {
    func didTapBottomButton() {
//        print("눌림")
        
        /// 숫자만 입력 되어있는지 확인
        guard let textFieldText = birthInputField.text else { return }
        if let convertedNum = Int(textFieldText) {
            if textFieldText.count == 8 {
                let ptn = "^[1-2]{1}[0-9]{3}[0-1]{1}[0-9]{1}[0-3]{1}[0-9]{1}$"
                let range = textFieldText.range(of: ptn, options: .regularExpression)
                if range == nil {
                    showToast(message: "8자리의 올바른 생년월일을 입력해주세요.", view: self.view)
                    return
                }
            } else {
                showToast(message: "8자리의 올바른 생년월일을 입력해주세요.", view: self.view)
                return
            }
        } else {
            showToast(message: "생년월일은 숫자로만 입력할 수 있습니다.", view: self.view)
            return
        }
        
        if let user = storageViewModel.getUserInfo(uuid: Constants.keyChainDeviceID) {
            let setUser = UserModel(uuid: user.uuid, isFirstLaunch: user.isFirstLaunch, agreeTerm: user.agreeTerm, agreePrivacy: user.agreePrivacy, agreeMarketing: user.agreeMarketing, birth: textFieldText, sex: userSex)
            storageViewModel.updateUser(setUser)
        }
        
        let vc = PickPaymentsViewController()
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
}
