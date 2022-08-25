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
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        return tableView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

}

extension TermsViewController: BackButtonProtocol, BottomButtonProtocol {
    func didTapBottomButton() {
        
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
        let bottomButton = BottomButton()
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
        let separatorLine: UIView = {
            let separatorLine = UIView()
            separatorLine.backgroundColor = UIColor.init(hex: 0xDBDEE8, alpha: 0.4)
            return separatorLine
        }()
        
        
        
        //MARK: ViewPropertyManual
        view.backgroundColor = .white
        navigationBar.title = "약관동의"
        allTermsCheck.require = nil
        allTermsCheck.titleText = "모두 확인 및 동의합니다."
        bottomButton.backgroundColor = .deactiveGray
        bottomButton.setTitle("동의 후 계속", for: .normal)
        bottomButton.setTitleColor(UIColor.init(hex: 0xAFB4C3), for: .normal)
        tableView.register(TermsTableViewCell.self, forCellReuseIdentifier: TermsTableViewCell.cellId)
        
        
        //MARK: AddSubView
        view.addSubview(navigationBar)
        view.addSubview(descLabel)
        view.addSubview(termsWrapView)
        termsWrapView.addSubview(allTermsCheck)
        termsWrapView.addSubview(separatorLine)
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
        allTermsCheck.snp.makeConstraints {
            $0.bottom.equalTo(termsWrapView)
            $0.height.equalTo(50)
            $0.leading.trailing.equalTo(termsWrapView)
        }
        separatorLine.snp.makeConstraints {
            $0.leading.trailing.equalTo(termsWrapView)
            $0.top.equalTo(allTermsCheck)
            $0.height.equalTo(1)
        }
        tableView.snp.makeConstraints {
            $0.leading.trailing.equalTo(termsWrapView)
            $0.bottom.equalTo(separatorLine.snp.top)
            $0.height.equalTo(150)
        }
        bottomButton.snp.makeConstraints {
            $0.bottom.equalTo(safeArea)
            $0.leading.trailing.equalTo(safeArea)
            $0.height.equalTo(56)
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
    func didTapCheckButton(_ sender: UIView) {
        print("델리게이트 호출")
        print(sender)
    }
    
    func didTapLinkButton(_ sender: UIView) {
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TermsModel.lists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TermsTableViewCell.cellId, for: indexPath) as? TermsTableViewCell else { return UITableViewCell() }
        cell.selectionStyle = .none
        cell.contentView.isUserInteractionEnabled = false
        cell.cellView.require = TermsModel.lists[indexPath.row].require
        cell.cellView.titleText = TermsModel.lists[indexPath.row].title
        cell.cellView.link = TermsModel.lists[indexPath.row].link
        return cell
    }
    

    
}
