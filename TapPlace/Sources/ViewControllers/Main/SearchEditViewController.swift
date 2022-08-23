//
//  SearchEditViewController.swift
//  TapPlace
//
//  Created by 이상준 on 2022/08/20.
//

import UIKit

class SearchEditViewController: CommonViewController {
    
    // 더미 데이터
    var searchingData = ["세븐 일레븐 등촌 3호점", "BBQ 등촌행복점", "세븐 일레븐 등촌 3호점", "BBQ 등촌행복점"]
    var img = [
        UIImage(systemName: "fork.knife.circle.fill"),
        UIImage(systemName: "fork.knife.circle.fill"),
        UIImage(systemName: "fork.knife.circle.fill"),
        UIImage(systemName: "fork.knife.circle.fill")
    ]
    
    var chooseItem = 0
    
    let navigationBar = NavigationBar() // 커스텀 네비게이션 바
    let leftBtn = EditButton() // 전체 선택 버튼
    let rightBtn = EditButton() // 삭제 버튼
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        configureTableView()
        setLayout()
        navigationBar.delegate = self
        leftBtn.delegate = self
        rightBtn.delegate = self
    }
    
    private lazy var editTableView: UITableView = {
        let editTableView = UITableView()
        editTableView.translatesAutoresizingMaskIntoConstraints = false
        editTableView.register(SearchEditTableViewCell.self, forCellReuseIdentifier: SearchEditTableViewCell.identifier)
        editTableView.allowsSelection = true
        return editTableView
    }()
    
    // 테이블 뷰 구성
    private func configureTableView() {
        self.editTableView.dataSource = self
        self.editTableView.delegate = self
        self.editTableView.backgroundColor = .white
        self.editTableView.keyboardDismissMode = .onDrag // 테이블 뷰 스크롤시 키보드 내리기
    }
}

extension SearchEditViewController {
    
    private func setupView() {
        self.view.backgroundColor = .white
    }
    
    private func setLayout() {
        
        let safeArea = view.safeAreaLayoutGuide
        
        let titleLabel: UILabel = {
            let titleLabel = UILabel()
            titleLabel.font = UIFont(name: "AppleSDGothicNeoM00-Regular", size: 17)
            titleLabel.text = "검색내역 편집"
            return titleLabel
        }()
        
        leftBtn.backgroundColor = .white
        leftBtn.titleLabel?.font = UIFont(name: "AppleSDGothicNeoSB00-Regular", size: 16)
        leftBtn.setTitle("전체선택", for: .normal)
        leftBtn.setTitleColor(UIColor(red: 0.722, green: 0.741, blue: 0.8, alpha: 1), for: .normal)
        
        rightBtn.backgroundColor =  UIColor(red: 0.969, green: 0.973, blue: 0.98, alpha: 1)
        rightBtn.titleLabel?.font = UIFont(name: "AppleSDGothicNeoSB00-Regular", size: 16)
        rightBtn.setTitle("삭제", for: .normal)
        rightBtn.setTitleColor(UIColor(red: 0.722, green: 0.741, blue: 0.8, alpha: 1), for: .normal)
        
        view.addSubview(navigationBar)
        navigationBar.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(safeArea)
            $0.width.equalTo(self.view.frame.width)
            $0.height.equalTo(60)
        }
        
        navigationBar.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.top).offset(27)
            $0.leading.equalTo(navigationBar.snp.leading).offset(43)
        }
        
        view.addSubview(editTableView)
        editTableView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.leading.trailing.bottom.equalTo(safeArea)
        }
        
        view.addSubview(leftBtn)
        leftBtn.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-55)
            $0.leading.bottom.equalToSuperview()
            $0.width.equalTo(self.view.frame.width / 2)
        }
        
        view.addSubview(rightBtn)
        rightBtn.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-55)
            $0.trailing.bottom.equalToSuperview()
            $0.width.equalTo(self.view.frame.width / 2)
        }
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // 탭바
        print("뷰 사라집니다.")
        tabBar?.showTabBar(hide: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 탭바
        print("뷰 나타납니다.")
        tabBar?.showTabBar(hide: true)
    }
}


// MARK: - 네비게이션 바 backbutton 프로토콜 구현
extension SearchEditViewController: BackButtonProtocol {
    func popViewVC() {
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: - 하단 전체선택 삭제 버튼 프로토콜 구현
extension SearchEditViewController: EditButtonProtocol {
    func didTapButton(_ sender: EditButton) {
        if sender == leftBtn {
            
        } else {
            
        }
    }
}

// MARK: - 테이블 뷰 데이터 소스, 델리게이트 설정
extension SearchEditViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        searchingData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchEditTableViewCell.identifier, for: indexPath) as! SearchEditTableViewCell
        
        cell.backgroundColor = .white
        cell.checkButton.setImage(UIImage(systemName: "checkmark.circle"), for: .normal)
        cell.img.image = self.img[indexPath.row] ?? UIImage(systemName: "")
        cell.label.text = self.searchingData[indexPath.row]
        cell.index = indexPath
        cell.delegate = self
        
        return cell
    }
    
    // 테이블 뷰 셀의 높이
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 54
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}

// MARK: - Cell 체크 버튼 프로토콜
extension SearchEditViewController: CheckButtonProtocol {
    func check(index: Int) {
        chooseItem += 1
        rightBtn.backgroundColor = UIColor.pointBlue
        rightBtn.setTitleColor(.white, for: .normal)
        rightBtn.setTitle("삭제\(chooseItem)", for: .normal)
    }
}
