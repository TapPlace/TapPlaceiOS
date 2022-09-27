//
//  InquiryHistoryViewController.swift
//  TapPlace
//
//  Created by 이상준 on 2022/09/27.
//

import Foundation
import UIKit

// 문의내역
class InquiryHistoryViewController: UIViewController {
    let customNavigationBar = CustomNavigationBar()
    
    override func viewDidLoad() {
        setupView()
        setLayout()
        
        customNavigationBar.delegate = self
        customNavigationBar.isDrawShadow = false
        customNavigationBar.isDrawBottomLine = false
        customNavigationBar.titleText = "문의내역"
        customNavigationBar.isUseLeftButton = true
    }
    
    private lazy var inquiryTableView: UITableView = {
        let inquiryTableView = UITableView()
        inquiryTableView.translatesAutoresizingMaskIntoConstraints = false
        inquiryTableView.register(InquiryCell.self, forCellReuseIdentifier: InquiryCell.identifier)
        inquiryTableView.separatorInset.left = 20
        inquiryTableView.separatorInset.right = 20
        return inquiryTableView
    }()
}

extension InquiryHistoryViewController {
    private func setupView() {
        self.view.backgroundColor = .white
    }
    
    private func setLayout() {
        view.addSubview(customNavigationBar)
        customNavigationBar.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(customNavigationBar.containerView)
        }
    }
}

extension InquiryHistoryViewController: CustomNavigationBarProtocol {
    func didTapLeftButton() {
        self.navigationController?.popViewController(animated: true)
    }
}

//extension InquiryHistoryViewController: UITableViewDataSource, UITableViewDelegate {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//
//    }
//}
