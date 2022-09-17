//
//  NoticeViewController.swift
//  TapPlace
//
//  Created by 이상준 on 2022/09/05.
//

import UIKit

// 공지사항 
class NoticeViewController: CommonViewController {
    
    let customNavigationBar = CustomNavigationBar()
    private var noticeListVM: NoticeListViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setLayout()
        
        customNavigationBar.delegate = self
        customNavigationBar.isDrawShadow = false
        customNavigationBar.isDrawBottomLine = false
        customNavigationBar.titleText = "공지사항"
        customNavigationBar.isUseLeftButton = true
        
        NoticeDataService().getNotice(page: "1") { (notice, error) in
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
    
    private lazy var noticeTableView: UITableView = {
        let noticeTableView = UITableView()
        noticeTableView.register(NoticeCell.self, forCellReuseIdentifier: NoticeCell.identifier)
        noticeTableView.separatorInset.left = 20
        noticeTableView.separatorInset.right = 20
        noticeTableView.allowsSelection = false
        return noticeTableView
    }()
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
//        print("뷰 사라집니다.")
        tabBar?.hideTabBar(hide: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 탭바
//        print("뷰 나타납니다.")
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
        
        view.addSubview(noticeTableView)
        noticeTableView.snp.makeConstraints {
            $0.top.equalTo(customNavigationBar.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
}

extension NoticeViewController: CustomNavigationBarProtocol {
    func didTapLeftButton() {
        self.navigationController?.popViewController(animated: true)
    }
}

extension NoticeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 74
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return noticeListVM.numberOfRowsInSection(1)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NoticeCell.identifier, for: indexPath) as! NoticeCell
        let noticeVM = self.noticeListVM.searchAtIndex(indexPath.row)
        cell.prepare(title: noticeVM.title, content: noticeVM.content, writeDate: noticeVM.writeDate)
        return cell
    }
}
