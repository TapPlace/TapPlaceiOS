//
//  SuggestedViewController.swift
//  TapPlace
//
//  Created by 이상준 on 2022/09/17.
//

import Foundation
import UIKit

class SuggestedViewController: CommonViewController {
    
    
    var termView: Bool = false
    var privacyTerm = TermsModel(title: "개인정보 수집, 이용동의", isTerm: true, require: true, link: "\(Constants.tapplacePolicyUrl)", checked: false)
    var numberOfLetter: Int = 0 // 타이틀 글자수
    var type: MoreMenuModel.MoreMenuType = .edit
    
    let customNavigationBar = CustomNavigationBar()
    let contentPlaceholder: String = "잘못되었거나 변경된 정보가 있다면 알려주세요.\n예) 가맹점 이름: 00점 -> 00점"
    
    let editContentLbl: UILabel = {
        let titleLbl = UILabel()
        titleLbl.text = "수정내용"
        titleLbl.font = .systemFont(ofSize: 17)
        titleLbl.sizeToFit()
        return titleLbl
    }()
    
    let contentTextView: UITextView = {
        let contentTextView = UITextView()
        contentTextView.layer.cornerRadius = 8
        contentTextView.font = .systemFont(ofSize: 15)
        contentTextView.layer.borderWidth = 1
        contentTextView.layer.borderColor = UIColor.init(hex: 0xDBDEE8).cgColor
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
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(TermsTableViewCell.self, forCellReuseIdentifier: TermsTableViewCell.cellId)
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        return tableView
    }()
    
    let button: BottomButton = {
        let button = BottomButton()
        button.setButtonStyle(title: "요청하기", type: .activate, fill: true)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setLayout()
        
        customNavigationBar.delegate = self
        customNavigationBar.isDrawShadow = false
        customNavigationBar.isDrawBottomLine = false
        customNavigationBar.titleText = "정보 수정 요청"
        customNavigationBar.isUseLeftButton = true
        
        contentTextView.delegate = self
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

extension SuggestedViewController {
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // 탭바
        tabBar?.hideTabBar(hide: termView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 탭바
        tabBar?.hideTabBar(hide: true)
    }
    
    private func setupView() {
        self.view.backgroundColor = .white
        contentTextView.text = contentPlaceholder
    }
    
    private func setLayout() {
        let safeArea = view.safeAreaLayoutGuide
        
        view.addSubview(customNavigationBar)
        customNavigationBar.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(customNavigationBar.containerView)
        }
        
        view.addSubview(editContentLbl)
        editContentLbl.snp.makeConstraints {
            $0.top.equalTo(customNavigationBar.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(20)
        }
        
        view.addSubview(contentTextView)
        contentTextView.snp.makeConstraints {
            $0.top.equalTo(editContentLbl.snp.bottom).offset(10)
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
extension SuggestedViewController: CustomNavigationBarProtocol {
    func didTapLeftButton() {
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: - 텍스트 뷰 델리게이트(placeholder처리)
extension SuggestedViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .systemGray3 {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = contentPlaceholder
            textView.textColor = .systemGray3
        }
    }
}

// MARK: - 테이블 뷰 데이터소스, 델리게이트
extension SuggestedViewController: UITableViewDataSource, UITableViewDelegate, TermsProtocol {
    func checkReceiveTerm(term: TermsModel, currentTermIndex: Int) {
        guard let targetCell = tableView.cellForRow(at: IndexPath(row: currentTermIndex, section: 0)) as? TermsTableViewCell else { return }
        privacyTerm.checked = true
        targetCell.setCheck(check: true)
        termView.toggle()        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TermsTableViewCell.cellId, for: indexPath) as! TermsTableViewCell
        cell.selectionStyle = .none
        cell.contentView.isUserInteractionEnabled = false
        cell.setInitCell(isTerm: privacyTerm.isTerm, require: privacyTerm.require, title: privacyTerm.title, link: privacyTerm.link)
        cell.setCheck(check: privacyTerm.checked)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? TermsTableViewCell else { return }
        
        if privacyTerm.checked == true {
            privacyTerm.checked = false
            cell.setCheck(check: privacyTerm.checked)
        } else {
            let vc = TermsWebViewViewController()
            vc.termIndex = 0
            vc.term = privacyTerm
            vc.delegate = self
            termView.toggle()
            self.navigationController?.pushViewController(vc, animated: true)
            tabBar?.hideTabBar(hide: true)
        }
    }
}

// MARK: - 하단 버튼 프로토콜 구현
extension SuggestedViewController: BottomButtonProtocol {
    func didTapBottomButton() {
        if !button.isActive { return }
        
        var answerCheck = 0
        if privacyTerm.checked  == true {
            answerCheck = 1
        }
        
        if contentTextView.text == contentPlaceholder {
            showToast(message: "제안 내용을 작성해주세요.", view: self.view)
            return
        }
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        if !emailTest.evaluate(with: emailField.text) {
            showToast(message: "올바른 형식의 이메일을 입력해주세요.", view: self.view)
            return
        }
        
        button.isActive = false
        button.setButtonStyle(title: "문의하기", type: .disabled, fill: true)
        
        if let contentText = contentTextView.text, let emailText = emailField.text {
            let parameter: [String: Any] = [
                "key": "\(Constants.tapplaceApiKey)",
                "user_id": "\(Constants.keyChainDeviceID)",
                "category": type,
                "title": "수정제안요청",
                "content": contentText,
                "answer_check": answerCheck,
                "email": emailText,
                "os": "iOS"
            ]
            
            InquiryService().postInquiry(parameter: parameter) { response,error in
                if let error = error {
                    showToast(message: "서버에 오류가 있습니다.\n잠시후 다시 시도해주시기 바랍니다.", view: self.view)
                    self.button.setButtonStyle(title: "요청하기", type: .activate, fill: true)
                    return
                }
                if response == true {
                    showToast(message: "정보 수정 요청이 정상적으로 등록 되었습니다.", duration: 3, view: self.view)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        self.navigationController?.popViewController(animated: true)
                        self.button.setButtonStyle(title: "요청하기", type: .activate, fill: true)
                    }
                } else {
                    showToast(message: "알 수 없는 오류가 발생했습니다.\n입력 값을 확인 후 다시 시도해주시기 바랍니다.", view: self.view)
                    self.button.setButtonStyle(title: "요청하기", type: .activate, fill: true)
                }
            }
        }
    }
}
