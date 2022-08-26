//
//  TermsViewController.swift
//  TapPlace
//
//  Created by 박상현 on 2022/08/25.
//

import UIKit

class TermsViewController: UIViewController {

    let navigationBar = NavigationBar()
    let allTermsCheck = TermsItemView()
    
    var allTermsLists: [TermsModel] = TermsModel.lists

    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        return tableView
    }()
    let bottomButton = BottomButton()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

}

extension TermsViewController: BackButtonProtocol, BottomButtonProtocol {
    func didTapBottomButton() {
        if bottomButton.isActive == false { return }
        let vc = PrivacyViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func popViewVC() {
        self.navigationController?.popViewController(animated: true)
    }
    
    /**
     * @ 초기 레이아웃 설정
     * coder : sanghyeon
     */
    func setupView() {
        //MARK: ViewDefine
        let safeArea = view.safeAreaLayoutGuide
        let descLabel: UILabel = {
            let descLabel = UILabel()
            descLabel.sizeToFit()
            descLabel.numberOfLines = 0
            descLabel.attributedText = NSMutableAttributedString()
                .regular(string: "환영합니다.\n서비스 시작 전에", fontSize: CommonUtils.resizeFontSize(size: 23), color: UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1))
                .bold(string: "\n이용약관에 동의해주세요.", fontSize: CommonUtils.resizeFontSize(size: 23))
            descLabel.lineHeight(height: 7)
            return descLabel
        }()
        let termsWrapView: UIView = {
            let termsWrapView = UIView()
            return termsWrapView
        }()
        
        
        
        //MARK: ViewPropertyManual
        view.backgroundColor = .white
        navigationBar.title = "약관동의"
        bottomButton.backgroundColor = .deactiveGray
        bottomButton.setTitle("동의 후 계속", for: .normal)
        bottomButton.setTitleColor(UIColor.init(hex: 0xAFB4C3), for: .normal)
        tableView.register(TermsTableViewCell.self, forCellReuseIdentifier: TermsTableViewCell.cellId)
        
        
        //MARK: AddSubView
        view.addSubview(navigationBar)
        view.addSubview(descLabel)
        view.addSubview(termsWrapView)
        termsWrapView.addSubview(tableView)
        view.addSubview(bottomButton)
        
        
        //MARK: ViewContraints
        navigationBar.snp.makeConstraints {
            $0.top.equalTo(safeArea)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(60)
        }
        descLabel.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom).offset(60)
            $0.leading.trailing.equalTo(safeArea).inset(20)
            
        }
        termsWrapView.snp.makeConstraints {
            $0.leading.trailing.equalTo(safeArea).inset(22)
            $0.top.equalTo(descLabel.snp.bottom).offset(10)
            $0.bottom.equalTo(bottomButton.snp.top).offset(-30)
        }
        tableView.snp.makeConstraints {
            $0.bottom.leading.trailing.equalTo(termsWrapView)
            $0.height.equalTo(UInt(allTermsLists.count * 50))
        }
        bottomButton.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.leading.trailing.equalTo(safeArea)
            $0.top.equalTo(safeArea.snp.bottom).offset(-50)
        }
        
        //MARK: ViewAddTarget
        
        
        //MARK: Delegate
        navigationBar.delegate = self
        bottomButton.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        allTermsCheck.delegate = self
    }
}
//MARK: - TableView
extension TermsViewController: UITableViewDelegate, UITableViewDataSource, TermsItemProtocol {
    func didTapCheckButton(_ sender: UIView, index: Int) {
        print("델리게이트 호출")

    }
    
    func didTapLinkButton(_ sender: UIView) {
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allTermsLists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TermsTableViewCell.cellId, for: indexPath) as? TermsTableViewCell else { return UITableViewCell() }
        cell.selectionStyle = .none
        cell.contentView.isUserInteractionEnabled = false
        let term = allTermsLists[indexPath.row]
        cell.setInitCell(isTerm: term.isTerm, require: term.require, title: term.title, link: term.link)
        cell.setCheck(check: term.checked)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? TermsTableViewCell else { return }
        allTermsLists[indexPath.row].checked.toggle()
        let targetTerm = allTermsLists[indexPath.row]
        if targetTerm.link != "" {
            let vc = TermsWebViewViewController()
            vc.term = targetTerm
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true)
        }
        
//        cell.setCheck(check: targetTerm.checked)
//
//        if targetTerm.isTerm == false {
//            for i in 0...allTermsLists.count - 1 {
//                allTermsLists[i].checked = targetTerm.checked ? true : false
//            }
//            tableView.reloadData()
//        }
        bottomButtonUpdate()
    }
    
    func bottomButtonUpdate() {
        let requireTerms = allTermsLists.filter({ $0.require == true })
        let checkedRequire = allTermsLists.filter { $0.checked == true && $0.require == true && $0.read == true }
        let isRequireChecked = requireTerms.count == checkedRequire.count

        if isRequireChecked {
            bottomButton.backgroundColor = .pointBlue
            bottomButton.setTitleColor(.white, for: .normal)
            bottomButton.isActive = true
        } else {
            bottomButton.backgroundColor = .deactiveGray
            bottomButton.setTitleColor(UIColor.init(hex: 0xAFB4C3), for: .normal)
            bottomButton.isActive = false
        }
    }
    
}
