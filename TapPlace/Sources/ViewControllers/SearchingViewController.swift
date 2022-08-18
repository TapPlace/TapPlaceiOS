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
    var searchingData = ["세븐 일레븐 등촌 3호점", "BBQ 등촌행복점", "세븐 일레븐 등촌 3호점", "BBQ 등촌행복점"]
    var img = [
        UIImage(systemName: "fork.knife.circle.fill"),
        UIImage(systemName: "fork.knife.circle.fill"),
        UIImage(systemName: "fork.knife.circle.fill"),
        UIImage(systemName: "fork.knife.circle.fill")
    ]
    
    let recentSearchButton = SearchContentButton() // 최근 검색어 버튼
    let favoriteSearchButton = SearchContentButton() // 즐겨찾는 가맹점 버튼
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        configureTableView()
        setLayout()
    }
    
    // 검색 테이블 뷰
    private lazy var searchTableView: UITableView = {
        let searchTableView = UITableView()
        searchTableView.translatesAutoresizingMaskIntoConstraints = false
        searchTableView.register(SearchTableViewCell.self, forCellReuseIdentifier: SearchTableViewCell.identifier)
        searchTableView.allowsSelection = true
        return searchTableView
    }()
    
    // 텍스트 필드가 활성화 됬을 때 테이블 뷰
    private lazy var searchActionTableView: UITableView = {
        let searchActionTableView = UITableView()
        searchActionTableView.translatesAutoresizingMaskIntoConstraints = false
        searchActionTableView.register(SearchActionTabelViewCell.self, forCellReuseIdentifier: SearchActionTabelViewCell.identifier)
        return searchActionTableView
    }()
    
    
    private func configureTableView() {
        self.searchTableView.dataSource = self
        self.searchTableView.delegate = self
        self.searchTableView.backgroundColor = .white
        //        searchTableView.rowHeight = 54 // 셀 높이
        
        
        self.searchActionTableView.dataSource = self
        self.searchActionTableView.delegate = self
        self.searchActionTableView.backgroundColor = .white
        searchActionTableView.rowHeight = 72
    }
}


// MARK: - UI
extension SearchingViewController: UITextFieldDelegate, SearchContentButtonProtocol {
    func didTapButton(_ sender: SearchContentButton) {
        if sender.tag == 1 {
            DispatchQueue.main.async {
                self.recentSearchButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
                self.recentSearchButton.setTitleColor(.black, for: .normal)
                self.favoriteSearchButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
                self.favoriteSearchButton.setTitleColor(UIColor(red: 0, green: 0, blue: 0, alpha: 0.3), for: .normal)
            }
        } else {
            DispatchQueue.main.async {
                self.recentSearchButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
                self.recentSearchButton.setTitleColor(UIColor(red: 0, green: 0, blue: 0, alpha: 0.3), for: .normal)
                self.favoriteSearchButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
                self.favoriteSearchButton.setTitleColor(.black, for: .normal)
            }
        }
    }
    
    
    
    private func setupView() {
        view.backgroundColor = .white
    }
    

    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // 탭바
        guard let tabBar = tabBarController as? TabBarViewController else { return }
        print("뷰 사라집니다.")
        tabBar.showTabBar(hide: false)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 탭바
        guard let tabBar = tabBarController as? TabBarViewController else { return }
        print("뷰 나타납니다.")
        tabBar.showTabBar(hide: true)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        DispatchQueue.main.async {
            
        }
        return false
    }
    
    // 레이아웃 구성
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
            searchField.clearButtonMode = .always
            searchField.delegate = self
            return searchField
        }()
        
        // 선
        let lineView: UIView = {
            let lineView = UIView()
            lineView.backgroundColor = UIColor.systemGray5
            return lineView
        }()
        
        // 하단 뷰
        let bottomView: UIView = {
            let bottomView = UIView()
            bottomView.backgroundColor = .white
            return bottomView
        }()
        
        // 검색어 버튼
        recentSearchButton.setTitle("최근 검색어", for: .normal)
        recentSearchButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        recentSearchButton.setTitleColor(.black, for: .normal)
        recentSearchButton.tag = 1
        recentSearchButton.delegate = self
        
        favoriteSearchButton.setTitle("즐겨찾는 가맹점", for: .normal)
        favoriteSearchButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        favoriteSearchButton.setTitleColor(UIColor(red: 0, green: 0, blue: 0, alpha: 0.3), for: .normal)
        favoriteSearchButton.titleLabel?.textAlignment = .left
        favoriteSearchButton.tag = 2
        favoriteSearchButton.delegate = self
        
        
        // 편집 버튼
        let editButton: UIButton = {
            let editButton = UIButton()  // 편집 버튼
            editButton.setTitle("편집", for: .normal)
            editButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            editButton.setTitleColor(UIColor(red: 0, green: 0, blue: 0, alpha: 0.5), for: .normal)
            return editButton
        }()
        
        
        // 상단 뷰 AutoLayout
        view.addSubview(searchView)
        searchView.snp.makeConstraints {
            $0.top.equalTo(safeArea)
            $0.leading.equalTo(safeArea)
            $0.trailing.equalTo(safeArea)
            $0.width.equalTo(self.view.frame.width)
            $0.height.equalTo(60)
        }
        
        // 뒤로가기 버튼 AutoLayout
        searchView.addSubview(backButton)
        backButton.snp.makeConstraints {
            $0.top.equalTo(searchView.snp.top).offset(24)
            $0.leading.equalTo(searchView.snp.leading).offset(16)
            $0.width.equalTo(25)
            $0.height.equalTo(25)
        }
        
        // 검색 텍스트필드 AutoLayout
        searchView.addSubview(searchField)
        searchField.snp.makeConstraints {
            $0.top.equalTo(searchView.snp.top).offset(25)
            $0.leading.equalTo(backButton.snp.trailing).offset(8)
            $0.trailing.equalTo(searchView.snp.trailing).offset(-20)
        }
        
        // 라인 AutoLayout
        searchView.addSubview(lineView)
        lineView.snp.makeConstraints {
            $0.top.equalTo(searchView.snp.bottom)
            $0.width.equalTo(self.view.frame.width)
            $0.height.equalTo(1)
        }
        
        // 하단 뷰 AutoLayout
        view.addSubview(bottomView)
        bottomView.snp.makeConstraints {
            $0.top.equalTo(lineView.snp.bottom)
            $0.width.equalTo(self.view.frame.width)
            $0.height.equalTo(60)
        }
        
        // 최근 검색어 버튼 AutoLayout
        bottomView.addSubview(recentSearchButton)
        recentSearchButton.snp.makeConstraints {
            $0.top.equalTo(bottomView.snp.top).offset(20)
            $0.leading.equalTo(bottomView.snp.leading).offset(20)
            $0.width.equalTo(80)
            $0.height.equalTo(21)
        }
        
        // 즐겨찾는 가맹점 버튼 AutoLayout
        bottomView.addSubview(favoriteSearchButton)
        favoriteSearchButton.snp.makeConstraints {
            $0.top.equalTo(bottomView.snp.top).offset(20)
            $0.leading.equalTo(recentSearchButton.snp.trailing).offset(15)
            $0.width.equalTo(110)
            $0.height.equalTo(21)
        }
        
        bottomView.addSubview(editButton)
        editButton.snp.makeConstraints {
            $0.top.equalTo(bottomView.snp.top).offset(20)
            $0.trailing.equalTo(bottomView.snp.trailing).offset(-20)
            $0.width.equalTo(25)
            $0.height.equalTo(18)
        }
        
        // 테이블 뷰 AutoLayout
        view.addSubview(searchTableView)
        searchTableView.snp.makeConstraints {
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

// MARK: - 테이블 뷰 셀에 대한 설정
extension SearchingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchingData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.identifier, for: indexPath) as! SearchTableViewCell
        cell.backgroundColor = .white
        cell.img.image = self.img[indexPath.row] ?? UIImage(systemName: "")
        cell.label.text = self.searchingData[indexPath.row]
        cell.deleteButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        cell.index = indexPath
        cell.delegate = self
        
        return cell
    }
    
    // 셀의 높이
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 54
    }
}

// MARK: - 최근 검색어 삭제
extension SearchingViewController: XBtnProtocol {
    func deleteCell(index: Int) {
        self.searchingData.remove(at: index)
        self.img.remove(at: index)
        self.searchTableView.reloadData()
    }
}
