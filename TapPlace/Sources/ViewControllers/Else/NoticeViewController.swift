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
    
    var noticeResult: [NoticeModel] = []
    var noticeApiPage = 1
    var isEnd = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setLayout()
        
        customNavigationBar.delegate = self
        customNavigationBar.isDrawShadow = false
        customNavigationBar.isDrawBottomLine = false
        customNavigationBar.titleText = "공지사항"
        customNavigationBar.isUseLeftButton = true
        
        // 공지사항 API 호출
        requestNotice()
    }
    
    private lazy var noticeTableView: UITableView = {
        let noticeTableView = UITableView()
        noticeTableView.translatesAutoresizingMaskIntoConstraints = false
        noticeTableView.register(NoticeCell.self, forCellReuseIdentifier: NoticeCell.identifier)
        noticeTableView.separatorInset.left = 20
        noticeTableView.separatorInset.right = 20
        noticeTableView.allowsSelection = true
        return noticeTableView
    }()
    
    // 공지사항 불러오기 서비스 호출 로직
    func requestNotice() {
        NoticeDataService().getNotice(page: "\(noticeApiPage)") { (notice, isEnd, error) in
            if let notice = notice {
                if notice.count > 0 {
                    self.view.addSubview(self.noticeTableView)
                    self.noticeTableView.snp.makeConstraints {
                        $0.top.equalTo(self.customNavigationBar.snp.bottom)
                        $0.leading.trailing.bottom.equalToSuperview()
                    }
                    
                    self.isEnd = isEnd
                    self.noticeListVM = NoticeListViewModel(noticeList: notice, isEnd: isEnd)
                    self.noticeResult += notice
                    self.configureTableView()
                } else {
                    let label: UILabel = {
                        let label = UILabel()
                        label.text = "등록된 공지사항이 없습니다."
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
                self.noticeTableView.reloadData()
            }
        }
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
        tabBar?.hideTabBar(hide: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 탭바
        tabBar?.hideTabBar(hide: true)
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
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 {
            return 0
        }
        return noticeResult.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NoticeCell.identifier, for: indexPath) as! NoticeCell
        let notice = self.noticeResult[indexPath.row]
        cell.selectionStyle = .none
        cell.prepare(title: notice.title, content: notice.content, writeDate: getOnlyDate(writeDate: notice.writeDate))
        return cell
    }
    
    // 공지사항 셀 선택시 해당 공지사항 상세보기 페이지로 이동
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("클릭됨: \(indexPath.row)")
        let notice = self.noticeResult[indexPath.row]
        let nextVC = NoticeDetailViewController()
        nextVC.noticeTitle = notice.title
        nextVC.content = notice.content
        nextVC.writeDate = getOnlyDate(writeDate: notice.writeDate)
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section != 1 || isEnd == true { return .zero }
        return 50
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section != 1 { return nil }
        let footerView = UIView()
        let expendButton = TableViewExpendButton(type: .system)
        expendButton.setTitle("공지사항 더보기", for: .normal)
        footerView.addSubview(expendButton)
        expendButton.snp.makeConstraints {
            $0.edges.equalTo(footerView)
        }
        expendButton.addTarget(self, action: #selector(didTapExpendButton), for: .touchUpInside)
        return footerView
    }
    
    @objc func didTapExpendButton() {
        if isEnd == true {
            showToast(message: "마지막 페이지 입니다.", view: self.view)
        } else {
            noticeApiPage += 1
            requestNotice()
        }
    }
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
