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
class SearchingViewController: UIViewController {
    
    let recordTableView = UITableView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.recordTableView.dataSource = self
//        self.recordTableView.delegate = self
//        
    
    }
}


extension SearchingViewController {
    
    private func setLayout() {
        
        // 검색바
        let searchBar: UISearchBar = {
            let searchBar = UISearchBar()
            searchBar.searchTextField.font = UIFont.systemFont(ofSize: 16)
            searchBar.placeholder = "가맹점을 찾아보세요"
            searchBar.searchTextField.backgroundColor = UIColor.clear
            self.navigationItem.titleView = searchBar
            searchBar.setImage(UIImage(), for: UISearchBar.Icon.search, state: .normal)
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(popViewController))
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(hideSearch))
            return searchBar
        }()
        
        //테이블 뷰
        
        
    }
    
    // 메인 화면으로 돌아가는 함수
    @objc func popViewController() {
        self.navigationController?.popViewController(animated: false)
    }
    
    // 이전 검색어 숨기는 함수
    @objc func hideSearch() {
        
    }
    
}

//extension SearchingViewController: UITableViewDelegate, UITableViewDataSource {
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 0
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        return cell
//    }
//
//}
