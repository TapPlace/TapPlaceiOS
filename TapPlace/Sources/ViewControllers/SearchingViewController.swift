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


extension SearchingViewController: SearchButtonProtocol {
    func didTapButton() {
        
    }
    
    private func setupView() {
        view.backgroundColor = .white
        //        self.navigationController?.navigationBar.isHidden = false
    }
    
    // 탭바 없애기
    func showTabBar(hide: Bool) {
        guard let tabBar = tabBarController as? TabBarViewController else { return }
        if hide {
            self.tabBarController?.tabBar.isHidden = true
            print("플로팅버튼 없앱니다.")
            tabBar.floatingButton.isHidden = true
        } else {
            self.tabBarController?.tabBar.isHidden = false
            print("플로팅버튼 없앱니다.")
            tabBar.floatingButton.isHidden = false
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("뷰 사라집니다.")
        showTabBar(hide: false)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("뷰 나타납니다.")
        showTabBar(hide: true)
    }
    
    private func setLayout() {
        let safeArea = view.safeAreaLayoutGuide
        
        // 상단 검색 뷰
        let searchView: UIView = {
            let searchView = UIView()
            searchView.backgroundColor = .white
            return searchView
        }()
        
        // 뒤로가기 버튼
        let backButton: UIButton = {
            let backButton = UIButton()
            backButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
            backButton.tintColor = .gray
            backButton.addTarget(self, action: #selector(moveMainController(_:)), for: .touchUpInside)
            return backButton
        }()
        
        // 검색 필드
        let searchField: UITextField = {
            let searchField = UITextField()
            searchField.font = UIFont(name: "AppleSDGothicNeoM00", size: 16)
            searchField.placeholder = "등록하려는 가맹점을 찾아보세요."
            
            return searchField
        }()
        
        // 선
        let lineView: UIView = {
            let lineView = UIView()
            lineView.backgroundColor = UIColor(red: 219, green: 222, blue: 232, alpha: 0.4)
            return lineView
        }()
        
        let bottomView: UIView = {
            let bottomView = UIView()
            bottomView.backgroundColor = .white
            return bottomView
        }()
        
        let recentSearchButton: SearchButton = {
            let recentSearchButton = SearchButton()
            recentSearchButton.setTitle("최근 검색어", for: .normal)
            recentSearchButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
            recentSearchButton.setTitleColor(.black, for: .normal)
            recentSearchButton.tag = 1
            recentSearchButton.delegate = self
            return recentSearchButton
        }()
        
        let favoriteSearchButton: SearchButton = {
            let favoriteSearchLabel = SearchButton()
            favoriteSearchLabel.setTitle("즐겨찾는 가맹점", for: .normal)
            favoriteSearchLabel.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            favoriteSearchLabel.setTitleColor(UIColor(red: 0, green: 0, blue: 0, alpha: 0.3), for: .normal)
            favoriteSearchLabel.tag = 2
            favoriteSearchLabel.delegate = self
            return favoriteSearchLabel
        }()
        
        // 상단 뷰
        view.addSubview(searchView)
        searchView.snp.makeConstraints {
            $0.top.equalTo(safeArea)
            $0.leading.equalTo(safeArea)
            $0.trailing.equalTo(safeArea)
            $0.width.equalTo(self.view.frame.width)
            $0.height.equalTo(55)
        }
        
        // 뒤로가기 버튼
        searchView.addSubview(backButton)
        backButton.snp.makeConstraints {
            $0.top.equalTo(searchView.snp.top).offset(24)
            $0.leading.equalTo(searchView.snp.leading).offset(16)
            $0.width.equalTo(25)
            $0.height.equalTo(25)
        }
        
        // 검색 텍스트필드
        searchView.addSubview(searchField)
        searchField.snp.makeConstraints {
            $0.top.equalTo(searchView.snp.top).offset(25)
            $0.leading.equalTo(backButton.snp.trailing).offset(8)
            $0.width.equalTo(250)
        }
        
        // 라인
        searchView.addSubview(lineView)
        lineView.snp.makeConstraints {
            $0.top.equalTo(searchView.snp.bottom)
            $0.width.equalTo(self.view.frame.width)
            $0.height.equalTo(1)
        }
        
        // 검색어 버튼 뷰
        view.addSubview(bottomView)
        bottomView.snp.makeConstraints {
            $0.top.equalTo(lineView.snp.bottom)
            $0.width.equalTo(self.view.frame.width)
            $0.height.equalTo(60)
        }
        
        bottomView.addSubview(recentSearchButton)
        recentSearchButton.snp.makeConstraints {
            $0.top.equalTo(bottomView.snp.top).offset(20)
            $0.leading.equalTo(bottomView.snp.leading).offset(20)
            $0.width.equalTo(80)
            $0.height.equalTo(21)
        }
        
        
        bottomView.addSubview(favoriteSearchButton)
        favoriteSearchButton.snp.makeConstraints {
            $0.top.equalTo(bottomView.snp.top).offset(20)
            $0.leading.equalTo(recentSearchButton.snp.trailing).offset(16)
            $0.width.equalTo(110)
            $0.height.equalTo(21)
            
        }
        
        // 테이블 뷰
        view.addSubview(searchingTableView)
        searchingTableView.snp.makeConstraints {
            $0.top.equalTo(bottomView.snp.bottom)
            $0.leading.equalTo(safeArea)
            $0.trailing.equalTo(safeArea)
            $0.bottom.equalTo(safeArea)
        }
    }
    
    // main으로 이동
    @objc func moveMainController(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
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
