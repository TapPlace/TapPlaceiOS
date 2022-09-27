//
//  SuggestedViewController.swift
//  TapPlace
//
//  Created by 이상준 on 2022/09/17.
//

import Foundation
import UIKit

// 정보 수정제안
class SuggestedViewController: CommonViewController {
    
    
    var termView: Bool = false
    var term = TermsModel(title: "개인정보 수집, 이용동의", isTerm: true, require: true, link: "\(Constants.tapplacePolicyUrl)", checked: false)
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
        tabBar?.hideTabBar(hide: true)
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
            $0.top.equalTo(customNavigationBar.snp.bottom).offset(30)
            $0.leading.equalToSuperview().offset(20)
        }
        
        view.addSubview(contentTextView)
        contentTextView.snp.makeConstraints {
            $0.top.equalTo(editContentLbl.snp.bottom).offset(10)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.height.equalTo(190)
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
        guard let targetCell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? TermsTableViewCell else { return }
        targetCell.setCheck(check: term.checked)
    }
    
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
            pushTermVC(term)
        }
    }
    
    func pushTermVC(_ term: TermsModel) {
        let vc = TermsWebViewViewController()
        vc.term = term
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - 하단 버튼 프로토콜 구현
extension SuggestedViewController: BottomButtonProtocol {
    func didTapBottomButton() {
        if !button.isActive { return }
        
        var answerCheck = 0
        if term.checked  == true {
            answerCheck = 1
        }
        
        if contentTextView.text == contentPlaceholder {
            showToast(message: "제안 내용을 작성해주세요.", view: self.view)
            return
        }
        
        button.isActive = false
        button.setButtonStyle(title: "문의하기", type: .disabled, fill: true)
        
        if let contentText = contentTextView.text {
            if contentText.count != 0 {
                if answerCheck != 1 {
                    showToast(message: "개인정보 수집, 이용동의를 체크해주시기 바랍니다.", view: self.view)
                    self.button.setButtonStyle(title: "문의하기", type: .activate, fill: true)
                    return
                }
                let parameter: [String: Any] = [
                    "key": "\(Constants.tapplaceApiKey)",
                    "user_id": "\(Constants.keyChainDeviceID)",
                    "category": type,
                    "title": "수정제안요청",
                    "content": contentText,
                    "answer_check": answerCheck,
                    "os": "iOS"
                ]
                
                InquiryService().postInquiry(parameter: parameter) { response,error in
                    if let error = error {
                        showToast(message: "알 수 없는 오류가 발생했습니다.\n입력 값을 확인 후 다시 시도해주시기 바랍니다.", view: self.view)
                        self.button.setButtonStyle(title: "요청하기", type: .activate, fill: true)
                        return
                    }
                    if response == true {
                        showToast(message: "정보 수정 요청이 정상적으로 등록 되었습니다.", duration: 3, view: self.view)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                            self.navigationController?.popViewController(animated: true)
                            self.button.setButtonStyle(title: "요청하기", type: .activate, fill: true)
                            self.contentTextView.text = self.contentPlaceholder
                            self.contentTextView.textColor = .systemGray3
                            guard let cell = self.tableView.cellForRow(at: IndexPath.init(row: 0, section: 0)) as? TermsTableViewCell else { return }
                            cell.setCheck(check: false)
                            answerCheck = 0
                        }
                    }
                }
            } else {
                showToast(message: "입력 값을 모두 채워주시기 바랍니다.", view: self.view)
                self.button.setButtonStyle(title: "문의하기", type: .activate, fill: true)
            }
        }
    }
}
