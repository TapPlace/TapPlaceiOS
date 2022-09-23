//
//  NoticeViewController.swift
//  TapPlace
//
//  Created by 이상준 on 2022/09/05.
//

import UIKit

// MARK: - 공지사항VC
class NoticeViewController: CommonViewController {
    
    let customNavigationBar = CustomNavigationBar()
    private var noticeListVM: NoticeListViewModel!
    var noticeApiPage = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setLayout()
        
        customNavigationBar.delegate = self
        customNavigationBar.isDrawShadow = false
        customNavigationBar.isDrawBottomLine = false
        customNavigationBar.titleText = "공지사항"
        customNavigationBar.isUseLeftButton = true
    }
    
    private lazy var noticeTableView: UITableView = {
        let noticeTableView = UITableView()
        noticeTableView.translatesAutoresizingMaskIntoConstraints = false
        noticeTableView.register(NoticeCell.self, forCellReuseIdentifier: NoticeCell.identifier)
        noticeTableView.separatorInset.left = 20
        noticeTableView.separatorInset.right = 20
        noticeTableView.allowsSelection = false
        return noticeTableView
    }()
    
    // 공지사항 불러오기 서비스 호출 로직
    func requestNotice() {
        
    }
    
}


extension NoticeViewController {
    private func setupView() {
        self.view.backgroundColor = .white
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // 탭바
        tabBar?.hideTabBar(hide: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 탭바
        tabBar?.hideTabBar(hide: true)
        
        // 공지사항 API 호출
        NoticeDataService().getNotice(page: "\(noticeApiPage)") { (notice, error) in
            if let notice = notice {
                print("나와나와 \(notice)")
                self.noticeListVM = NoticeListViewModel(notice: notice)
                self.configureTableView()
            }
            
            DispatchQueue.main.async {
                self.noticeTableView.reloadData()
            }
        }
    }
    
    // 테이블 뷰 구성 메소드
    private func configureTableView() {
        self.noticeTableView.dataSource = self
        self.noticeTableView.delegate = self
        self.noticeTableView.backgroundColor = .white
    }
    
    private func setLayout() {
        
        view.addSubview(customNavigationBar)
        customNavigationBar.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(customNavigationBar.containerView)
        }
        
        view.addSubview(noticeTableView)
        noticeTableView.snp.makeConstraints {
            $0.top.equalTo(customNavigationBar.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
}

// MARK: - 커스텀 네비게이션 바 프로토콜 구현
extension NoticeViewController: CustomNavigationBarProtocol {
    func didTapLeftButton() {
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: - 테이블 뷰 델리게이트, 데이터소스
extension NoticeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 74
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return noticeListVM.numberOfRowsInSection(1)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NoticeCell.identifier, for: indexPath) as! NoticeCell
        let noticeVM = self.noticeListVM.searchAtIndex(indexPath.row)
        cell.prepare(title: noticeVM.title, content: noticeVM.content, writeDate: getOnlyDate(writeDate: noticeVM.writeDate))
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        let expendButton = TableViewExpendButton(type: .system)
        expendButton.setTitle("공지사항 더보기", for: .normal)
        footerView.addSubview(expendButton)
        expendButton.snp.makeConstraints {
            $0.edges.equalTo(footerView)
        }
    
//        expendButton.addTarget(self, action: #selector(didTapExpendButton), for: .touchUpInside)
        return footerView
    }
    
//    @objc func didTapExpendButton() {
//        if isEndPage {
//            showToast(message: "마지막 검색 결과 입니다.", view: self.view)
//        } else {
//            isPaging += 1
//            requestPlace()
//        }
//    }
}

// MARK: - 시간 관련
extension NoticeViewController {
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
