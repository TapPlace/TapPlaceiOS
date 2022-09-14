//
//  TermsViewController.swift
//  TapPlace
//
//  Created by 박상현 on 2022/08/25.
//

import UIKit

class TermsViewController: UIViewController {

    var storageViewModel = StorageViewModel()
    
    let customNavigationBar = CustomNavigationBar()
    let allTermsCheck = TermsItemView()
    
    var allTermsLists: [TermsModel] = TermsModel.lists
    var isAllCheck: Bool = false

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

extension TermsViewController: CustomNavigationBarProtocol, BottomButtonProtocol {
    func didTapBottomButton() {
        if bottomButton.isActive == false {
            showToast(message: "약관을 모두 확인해주세요.", duration: 3.0, view: self.view)
            return
        }
        if let user = storageViewModel.getUserInfo(uuid: Constants.userDeviceID) {
            //guard let marketingIndex = allTermsLists.firstIndex(where: { $0.title == "마케팅 정보 수신 동의" }) else { return }
            let isCheckedMarketing = false //allTermsLists[marketingIndex].checked
            let setUser = UserModel(uuid: user.uuid, isFirstLaunch: user.isFirstLaunch, agreeTerm: LatestTermsModel.latestServiceDate, agreePrivacy: LatestTermsModel.latestPersonalDate, agreeMarketing: isCheckedMarketing ? CommonUtils.getDate(Date(), type: 3) : "", birth: "", sex: "")
            storageViewModel.updateUser(setUser)
        }
        let vc = PrivacyViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func didTapLeftButton() {
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
        self.navigationController?.navigationBar.isHidden = true
        view.backgroundColor = .white
        customNavigationBar.titleText = "약관동의"
        bottomButton.setButtonStyle(title: "동의 후 계속", type: .disabled, fill: true)
        tableView.register(TermsTableViewCell.self, forCellReuseIdentifier: TermsTableViewCell.cellId)
        
        
        //MARK: AddSubView
        view.addSubview(customNavigationBar)
        view.addSubview(descLabel)
        view.addSubview(termsWrapView)
        termsWrapView.addSubview(tableView)
        view.addSubview(bottomButton)
        
        
        //MARK: ViewContraints
        customNavigationBar.snp.makeConstraints {
            $0.top.equalTo(safeArea)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(60)
        }
        descLabel.snp.makeConstraints {
            $0.top.equalTo(customNavigationBar.snp.bottom).offset(60)
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
        customNavigationBar.delegate = self
        bottomButton.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        allTermsCheck.delegate = self
    }
} 
//MARK: - TableView
extension TermsViewController: UITableViewDelegate, UITableViewDataSource, TermsItemProtocol, TermsProtocol {
    func checkReceiveTerm(term: TermsModel, currentTermIndex: Int) {
        guard let targetIndex = allTermsLists.firstIndex(where: { $0.title == term.title }) else { return }
        guard let targetCell = tableView.cellForRow(at: IndexPath(row: targetIndex, section: 0)) as? TermsTableViewCell else { return }
        allTermsLists[targetIndex] = term
        targetCell.setCheck(check: term.checked)
        allCheckTermsCell()
        bottomButtonUpdate()
        
        /// 모두 동의일 경우 다음 약관 표시 로직
        if isAllCheck {
            guard let nonCheckRequireTerm = allTermsLists.firstIndex(where: {$0.require == true && $0.read == false && $0.checked == false }) else { return }
            DispatchQueue.main.async {
                self.pushTermVC(self.allTermsLists[nonCheckRequireTerm], index: nonCheckRequireTerm)
            }
        }
        
        
    }
    
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
        let targetTerm = allTermsLists[indexPath.row]
        guard let targetIndex = allTermsLists.firstIndex(where: { $0.title == targetTerm.title }) else { return }
        
        
        /// 이미 체크된 항목의 경우 별도의 로직 없이 체크만 해제함
        if targetTerm.checked {
            allTermsLists[targetIndex].checked.toggle()
            allTermsLists[targetIndex].read.toggle()
            cell.setCheck(check: allTermsLists[targetIndex].checked)
            allCheckTermsCell()
            bottomButtonUpdate()
            return
        }
        
        allTermsLists[indexPath.row].checked.toggle()
        
        if targetTerm.link != "" && targetTerm.isTerm {
            pushTermVC(targetTerm, index: targetIndex)
        } else if targetTerm.isTerm {
            cell.setCheck(check: allTermsLists[targetIndex].checked)
        }
        
        /// 모두 동의 버튼 눌렀을 경우
        if targetTerm.isTerm == false {
            isAllCheck = true
            allTermsLists.enumerated().forEach {
                if $1.require != true {
                    allTermsLists[$0].read = true
                    allTermsLists[$0].checked = true
                }
            }
            tableView.reloadData()
            pushTermVC(allTermsLists[0], index: 0)
        }
        allCheckTermsCell()
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
    
    func allCheckTermsCell() {
        /// 체크 항목에 따라 모두동의 버튼 변경
        let allCheckTermsIndexPath = IndexPath(row: allTermsLists.count - 1, section: 0)
        guard let allCheckTermsCell = tableView.cellForRow(at: allCheckTermsIndexPath) as? TermsTableViewCell else { return }
        print(allTermsLists.filter({$0.isTerm == true}).count == allTermsLists.filter({$0.isTerm == true && $0.checked}).count)
        if allTermsLists.filter({$0.isTerm == true}).count == allTermsLists.filter({$0.isTerm == true && $0.checked}).count {
            allCheckTermsCell.setCheck(check: true)
        } else {
            allCheckTermsCell.setCheck(check: false)
        }
    }
    
    func pushTermVC(_ term: TermsModel, index: Int) {
        let vc = TermsWebViewViewController()
        vc.termIndex = index
        vc.term = term
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
