//
//  InquiryViewController.swift
//  TapPlace
//
//  Created by 이상준 on 2022/09/06.
//

import UIKit
import RealmSwift

// 문의하기, 수정하기
class InquiryViewController: CommonViewController {
    var term = TermsModel(title: "개인정보 수집, 이용동의", isTerm: true, require: true, link: "", checked: false)
    var numberOfLetter: Int = 0 // 타이틀 글자수
    var type: MoreMenuModel.MoreMenuType = .qna
    
    let customNavigationBar = CustomNavigationBar()
    
    let titleLbl: UILabel = {
        let titleLbl = UILabel()
        titleLbl.text = "문의제목"
        titleLbl.font = .systemFont(ofSize: 17)
        titleLbl.sizeToFit()
        return titleLbl
    }()
    
    let titleField: UITextField = {
        let titleField = UITextField()
        titleField.layer.cornerRadius = 8
        titleField.layer.borderWidth = 1
        titleField.layer.borderColor = UIColor.init(hex: 0xDBDEE8).cgColor
        titleField.font = .systemFont(ofSize: 15)
        titleField.setLeftPaddingPoints(15)
        titleField.placeholder = "제목을 입력해주세요. (20자 이내)"
        return titleField
    }()
    
    let countingTextLbl = UILabel()
    
    let contentLbl: UILabel = {
        let contentLbl = UILabel()
        contentLbl.text = "문의내용"
        contentLbl.font = .systemFont(ofSize: 17)
        contentLbl.sizeToFit()
        return contentLbl
    }()
    
    let contentTextView: UITextView = {
        let contentTextView = UITextView()
        contentTextView.layer.cornerRadius = 8
        contentTextView.font = .systemFont(ofSize: 15)
        contentTextView.layer.borderWidth = 1
        contentTextView.layer.borderColor = UIColor.init(hex: 0xDBDEE8).cgColor
        contentTextView.text =  "문의하실 내용을 남겨주세요."
        contentTextView.textColor = .systemGray3
        
        // 텍스트 간격
        contentTextView.textContainerInset = UIEdgeInsets(top: 13, left: 14, bottom: 15, right: 13)
        return contentTextView
    }()
    
    let emailLbl: UILabel = {
        let emailLbl = UILabel()
        emailLbl.text = "이메일 주소"
        emailLbl.font = .systemFont(ofSize: 17)
        emailLbl.sizeToFit()
        return emailLbl
    }()
    
    let emailField: UITextField = {
        let emailField = UITextField()
        emailField.layer.cornerRadius = 8
        emailField.layer.borderWidth = 1
        emailField.layer.borderColor = UIColor.init(hex: 0xDBDEE8).cgColor
        emailField.font = .systemFont(ofSize: 15)
        emailField.setLeftPaddingPoints(15)
        emailField.placeholder = "답변 받을 이메일 주소를 알려주세요."
        return emailField
    }()
    
    let termsWrapView: UIView = {
        let termsWrapView = UIView()
        return termsWrapView
    }()
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(TermsTableViewCell.self, forCellReuseIdentifier: TermsTableViewCell.cellId)
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        return tableView
    }()
    
    let button: BottomButton = {
        let button = BottomButton()
        button.setButtonStyle(title: "문의하기", type: .activate, fill: true)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setLayout()
        
        customNavigationBar.delegate = self
        customNavigationBar.isDrawShadow = false
        customNavigationBar.isDrawBottomLine = false
        customNavigationBar.titleText = "문의하기"
        customNavigationBar.isUseLeftButton = true
        
        contentTextView.delegate = self
        
        titleField.delegate = self
        contentTextView.delegate = self
        emailField.delegate = self
        button.delegate = self
        
        button.isActive = true
        
        configureTableView()
    }
    
    private func configureTableView() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.backgroundColor = .white
    }
}

extension InquiryViewController {
    private func setupView() {
        self.view.backgroundColor = .white
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // 탭바
//        print("뷰 사라집니다.")
        tabBar?.hideTabBar(hide: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 탭바
//        print("뷰 나타납니다.")
        tabBar?.hideTabBar(hide: true)
    }
    
    private func setLayout() {
        let safeArea = view.safeAreaLayoutGuide
        
        countingTextLbl.text = "\(numberOfLetter)/20"
        countingTextLbl.font = .systemFont(ofSize: 15)
        countingTextLbl.textColor = .systemGray3
        countingTextLbl.sizeToFit()
        
        view.addSubview(customNavigationBar)
        customNavigationBar.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(customNavigationBar.containerView)
        }
        
        view.addSubview(titleLbl)
        titleLbl.snp.makeConstraints {
            $0.top.equalTo(customNavigationBar.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(20)
        }
        
        view.addSubview(titleField)
        titleField.snp.makeConstraints {
            $0.top.equalTo(titleLbl.snp.bottom).offset(10)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.height.equalTo(48)
        }
        
        titleField.addSubview(countingTextLbl)
        countingTextLbl.snp.makeConstraints {
            $0.top.equalToSuperview().offset(14)
            $0.trailing.equalToSuperview().offset(-15)
        }
        
        view.addSubview(contentLbl)
        contentLbl.snp.makeConstraints {
            $0.top.equalTo(titleField.snp.bottom).offset(28)
            $0.leading.equalToSuperview().offset(20)
        }
        
        view.addSubview(contentTextView)
        contentTextView.snp.makeConstraints {
            $0.top.equalTo(contentLbl.snp.bottom).offset(10)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.height.equalTo(190)
        }
        
        view.addSubview(emailLbl)
        emailLbl.snp.makeConstraints {
            $0.top.equalTo(contentTextView.snp.bottom).offset(28)
            $0.leading.equalToSuperview().offset(20)
        }
        
        view.addSubview(emailField)
        emailField.snp.makeConstraints {
            $0.top.equalTo(emailLbl.snp.bottom).offset(10)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.height.equalTo(48)
        }
        
        view.addSubview(button)
        button.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-50)
        }
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.leading.trailing.equalTo(safeArea).inset(22)
            $0.height.equalTo(50)
            $0.bottom.equalTo(button.snp.top).offset(-15)
        }
    }
}

// MARK: - 커스텀 네비게이션 바 프로토콜 구현
extension InquiryViewController: CustomNavigationBarProtocol {
    func didTapLeftButton() {
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: - 텍스트 필드
extension UITextField {
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
}

// MARK: - 텍스트 필드 델리게이트
extension InquiryViewController: UITextFieldDelegate {
    // 키보드 자판 return 클릭시 문의내용 텍스트 뷰로 넘어가기
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == titleField {
            contentTextView.becomeFirstResponder()
        }
        else {
            contentTextView.resignFirstResponder()
        }
        
        if textField == emailField {
            self.view.endEditing(true)
            return false
        }
        return true
    }
    
    // 문의 제목 텍스트 수 20자 적용
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString text: String) -> Bool {
        if textField == titleField {
            let currentText = titleField.text ?? ""
            guard let stringRange = Range(range, in: currentText) else { return false }
            
            let changeText = currentText.replacingCharacters(in: stringRange, with: text)
            numberOfLetter = changeText.count
            countingTextLbl.text = "\(numberOfLetter)/20"
            
            return changeText.count <= 20
        } else { return true }
    }
}

// MARK: - 텍스트 뷰 델리게이트(placeholder처리)
extension InquiryViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .systemGray3 {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "문의하실 내용을 남겨주세요."
            textView.textColor = .systemGray3
        }
    }
}

// MARK: - 테이블 뷰 데이터소스, 델리게이트
extension InquiryViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TermsTableViewCell.cellId, for: indexPath) as! TermsTableViewCell
        cell.selectionStyle = .none
        cell.contentView.isUserInteractionEnabled = false
        cell.setInitCell(isTerm: term.isTerm, require: term.require, title: term.title, link: term.link)
        cell.setCheck(check: term.checked)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? TermsTableViewCell else { return }
        
        if term.checked == true {
            term.checked = false
            cell.setCheck(check: term.checked)
        } else {
            term.checked = true
            cell.setCheck(check: term.checked)
        }
    }
}

extension InquiryViewController: BottomButtonProtocol {
    func didTapBottomButton() {
        if !button.isActive { return }
        button.isActive = false
        button.setButtonStyle(title: "문의하기", type: .disabled, fill: true)
//        print("문의하기 버튼 눌림")

        
        var answerCheck = 0
        if term.checked  == true {
            answerCheck = 1
        }
        
        if let titleText = titleField.text, let contentText = contentTextView.text, let emailText = emailField.text {
//            print("옵셔널 바인딩 성공")
            
            let parameter: [String: Any] = [
                "key": "\(Constants.tapplaceApiKey)",
                "user_id": "\(Constants.userDeviceID)",
                "category": type,
                "title": titleText,
                "content": contentText,
                "answer_check": answerCheck,
                "email": emailText,
                "os": "iOS"
            ]
            
//            print(parameter)
            
            InquiryService().postInquiry(parameter: parameter) { response,error in
                if let error = error {
                    showToast(message: "서버에 오류가 있습니다.\n잠시후 다시 시도해주시기 바랍니다.", view: self.view)
                    self.button.setButtonStyle(title: "문의하기", type: .activate, fill: true)
                    return
                }
                if response == true {
                    showToast(message: "문의가 정상적으로 등록 되었습니다.", duration: 3, view: self.view)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        self.navigationController?.popViewController(animated: true)
                        self.button.setButtonStyle(title: "문의하기", type: .activate, fill: true)
                    }
                } else {
                    showToast(message: "알 수 없는 오류가 발생했습니다.\n입력 값을 확인 후 다시 시도해주시기 바랍니다.", view: self.view)
                    self.button.setButtonStyle(title: "문의하기", type: .activate, fill: true)
                }
            }
        }
    }
}
