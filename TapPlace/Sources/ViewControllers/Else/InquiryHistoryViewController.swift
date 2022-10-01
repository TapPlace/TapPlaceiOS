//
//  InquiryHistoryViewController.swift
//  TapPlace
//
//  Created by 이상준 on 2022/09/27.
//

import Foundation
import UIKit

// 문의내역
class InquiryHistoryViewController: CommonViewController {
    
    let customNavigationBar = CustomNavigationBar()
    private var inquiryListVM: InquiryListViewModel!
    
    var inquiryResult = [InquiryModel]()
    var inquiryPage = 1
    var isEnd = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setLayout()
        
        customNavigationBar.delegate = self
        customNavigationBar.isDrawShadow = false
        customNavigationBar.isDrawBottomLine = false
        customNavigationBar.titleText = "문의내역"
        customNavigationBar.isUseLeftButton = true
        
        requestInquiry()
        self.configureTableView()
    }
    
    private lazy var inquiryTableView: UITableView = {
        let inquiryTableView = UITableView()
        inquiryTableView.translatesAutoresizingMaskIntoConstraints = false
        inquiryTableView.register(InquiryCell.self, forCellReuseIdentifier: InquiryCell.identifier)
        inquiryTableView.separatorInset.left = 20
        inquiryTableView.separatorInset.right = 20
        return inquiryTableView
    }()
    
    func requestInquiry() {
        InquiryService().getInquiries(page: "\(inquiryPage)") { (inquiry, isEnd, error) in
            if let inquiry = inquiry {
                print(inquiry.count)
                self.inquiryListVM = InquiryListViewModel(inquiryList: inquiry, isEnd: isEnd)
                self.inquiryResult += inquiry
                print(self.inquiryResult.count)
                self.isEnd = isEnd
                
                if self.inquiryResult.count > 0 {
                    self.view.addSubview(self.inquiryTableView)
                    self.inquiryTableView.snp.makeConstraints {
                        $0.top.equalTo(self.customNavigationBar.snp.bottom)
                        $0.leading.trailing.bottom.equalToSuperview()
                    }
                } else {
                    let label: UILabel = {
                        let label = UILabel()
                        label.text = "등록된 문의내역이 없습니다."
                        label.font = .systemFont(ofSize: 18)
                        label.textColor = .init(hex: 0x707070)
                        return label
                    }()
                    
                    self.view.addSubview(label)
                    label.snp.makeConstraints {
                        $0.center.equalToSuperview()
                    }
                }
            }
            
            DispatchQueue.main.async {
                self.inquiryTableView.reloadData()
            }
        }
    }
}

extension InquiryHistoryViewController {
    private func setupView() {
        self.view.backgroundColor = .white
    }
    
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
        inquiryTableView.reloadData()
    }
    
    // 테이블 뷰 구성 메소드
    private func configureTableView() {
        self.inquiryTableView.dataSource = self
        self.inquiryTableView.delegate = self
        self.inquiryTableView.backgroundColor = .white
    }
    
    private func setLayout() {
        view.addSubview(customNavigationBar)
        customNavigationBar.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(customNavigationBar.containerView)
        }
    }
}

// MARK: - 커스텀 네비게이션 바 프로토콜 구현
extension InquiryHistoryViewController: CustomNavigationBarProtocol {
    func didTapLeftButton() {
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: - 테이블 뷰 데이터 소스, 델리게이트
extension InquiryHistoryViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1 {
            return 0
        }
        return 82
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 {
            return 0
        }
        return self.inquiryResult.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: InquiryCell.identifier, for: indexPath) as? InquiryCell else { fatalError("no matched articleTableViewCell identifier") }
            let inquiry = self.inquiryResult[indexPath.row]
            cell.selectionStyle = .none
            cell.prepare(title: inquiry.title, writeDate: self.getOnlyDate(writeDate: inquiry.writeDate), content: inquiry.content, answerCheck: inquiry.answerCheck)
            
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let inquiry = self.inquiryResult[indexPath.row]
        let nextVC = InquiryDetailViewController()
        nextVC.noticeTitle = inquiry.title
        nextVC.writeDate = self.getOnlyDate(writeDate: inquiry.writeDate)
        nextVC.content = inquiry.content
        nextVC.answer = inquiry.answer
        nextVC.answerCheck = inquiry.answerCheck
        
        if inquiry.answerDate != "" {
            nextVC.answerDate = self.getOnlyDate(writeDate: inquiry.answerDate)
        }
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section != 1 || isEnd == true { return .zero }
        return 50
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section != 1 { return nil }
        if isEnd { return nil }
        let footerView = UIView()
        let expendButton = TableViewExpendButton(type: .system)
        expendButton.setTitle("문의내역 더보기", for: .normal)
        footerView.addSubview(expendButton)
        expendButton.snp.makeConstraints {
            $0.edges.equalTo(footerView)
        }
        expendButton.addTarget(self, action: #selector(didTapExpendButton), for: .touchUpInside)
        return footerView
    }
    
    @objc func didTapExpendButton() {
        if isEnd {
            showToast(message: "마지막 페이지 입니다.", view: self.view)
        } else {
            inquiryPage += 1
            requestInquiry()
        }
    }
}

// MARK: - 시간 관련
extension InquiryHistoryViewController {
    func getOnlyDate(writeDate: String?) -> String {
        if writeDate != nil {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let convertDate = dateFormatter.date(from: writeDate ?? "2022-00-00 00:00:00")
            
            let stringDateFormatter = DateFormatter()
            stringDateFormatter.dateFormat = "yyyy.MM.dd"
            let result = stringDateFormatter.string(from: convertDate!)
            return result
        } else {
            return "2022.00.00"
        }
    }
}

