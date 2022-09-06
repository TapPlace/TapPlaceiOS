//
//  NoticeViewController.swift
//  TapPlace
//
//  Created by 이상준 on 2022/09/05.
//

import Foundation
import UIKit

class NoticeViewController: UIViewController {
    
    override func viewDidLoad() {
        setupView()
        setLayout()
        configureTableView()
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
    
    // 테이블 뷰 구성 메소드
    private func configureTableView() {
        self.noticeTableView.dataSource = self
        self.noticeTableView.delegate = self
        self.noticeTableView.backgroundColor = .white
    }
    
    private func setLayout() {
        let safeArea = view.safeAreaLayoutGuide
        
        let navigationBar: NavigationBar = {
            let navigationBar = NavigationBar()
            return navigationBar
        }()
        
        let naviTitle: UILabel = {
            let naviTitle = UILabel()
            naviTitle.font = .boldSystemFont(ofSize: 17)
            naviTitle.text = "공지사항"
            return naviTitle
        }()
        
        view.addSubview(navigationBar)
        navigationBar.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(safeArea)
            $0.width.equalTo(self.view.frame.width)
            $0.height.equalTo(60)
        }
        
        navigationBar.addSubview(naviTitle)
        naviTitle.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.top).offset(27)
            $0.leading.equalToSuperview().offset(44)
        }
        
        view.addSubview(noticeTableView)
        noticeTableView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
}

extension NoticeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 74
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return NoticeModel.lists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NoticeCell.identifier, for: indexPath) as! NoticeCell
        let noticeModel = NoticeModel.lists[indexPath.row]
        cell.prepare(content: noticeModel.content, date: noticeModel.time)
        return cell
    }
}
