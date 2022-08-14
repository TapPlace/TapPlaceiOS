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
        
        let searchController = UISearchController(searchResultsController: nil)
        self.navigationItem.searchController = searchController
        
//        self.recordTableView.dataSource = self
//        self.recordTableView.delegate = self
        
    
    }
}


extension SearchingViewController {
    
    private func layout() {
        
        let searchBar: UISearchBar = {
            let searchBar = UISearchBar()
            searchBar.setImage(UIImage(systemName: "chevron.left"), for: UISearchBar.Icon.search, state: .normal)
            return searchBar
        }()
        
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
