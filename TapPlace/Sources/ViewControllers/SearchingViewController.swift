//
//  SearchingViewController.swift
//  TapPlace
//
//  Created by 이상준 on 2022/08/14.
//

import Foundation
import SnapKit
import UIKit


// MARK: - 검색화면
class SearchingViewController: UISearchController {
    
    // 더미 데이터
    let searchingData = ["세븐 일레븐 등촌 3호점", "BBQ 등촌행복점", "세븐 일레븐 등촌 3호점", "BBQ 등촌행복점"]
    let img = [
        UIImage(systemName: "fork.knife.circle.fill"),
        UIImage(systemName: "fork.knife.circle.fill"),
        UIImage(systemName: "fork.knife.circle.fill"),
        UIImage(systemName: "fork.knife.circle.fill")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        configure()
        setLayout()
    }
    
    private let searchingTableView: UITableView = {
         let searchingTableView = UITableView()
         searchingTableView.translatesAutoresizingMaskIntoConstraints = false
         searchingTableView.register(SearchingTableViewCell.self, forCellReuseIdentifier: SearchingTableViewCell.identifier)
         return searchingTableView
    }()
    
    private func configure() {
        self.searchingTableView.dataSource = self
        self.searchingTableView.delegate = self
        searchingTableView.rowHeight = 54 // 셀 높이
    }
}


extension SearchingViewController {
    
    private func setupView() {
        view.backgroundColor = .white
    }
    
    
    private func setLayout() {
        let safeArea = view.safeAreaLayoutGuide
        
        let searchView: UIView = {
            let searchView = UIView()
            return searchView
        }()
        
        // 테이블 뷰 추가
        view.addSubview(searchingTableView)
        searchingTableView.snp.makeConstraints {
            $0.top.equalTo(self.view.snp_topMargin)
            $0.leading.equalTo(safeArea)
            $0.trailing.equalTo(safeArea)
            $0.bottom.equalTo(safeArea)
        }
        
    }
    
    // 메인 화면으로 돌아가는 함수
    @objc func popViewController() {
        self.navigationController?.popViewController(animated: false)
    }
    
    // 이전 검색어 숨기는 함수
    @objc func hideSearch() {
        
    }
    
}

extension SearchingViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchingData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchingTableViewCell.identifier, for: indexPath) as! SearchingTableViewCell
        cell.img.image = self.img[indexPath.row] ?? UIImage(systemName: "")
        cell.label.text = self.searchingData[indexPath.row] ?? ""
        return cell
    }
}
