//
//  SearchEditViewController.swift
//  TapPlace
//
//  Created by 이상준 on 2022/08/20.
//

import UIKit

class SearchEditViewController: CommonViewController {
    
    var selectedStoreID: [String] = []
    
    let customNavigationBar = CustomNavigationBar() // 커스텀 네비게이션 바
    let leftBtn = EditButton() // 전체 선택 버튼
    let rightBtn = EditButton() // 삭제 버튼
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        configureTableView()
        setLayout()
        
        customNavigationBar.delegate = self
        customNavigationBar.isDrawShadow = false
        customNavigationBar.isDrawBottomLine = false
        customNavigationBar.titleText = ""
        customNavigationBar.isUseLeftButton = true
        
        leftBtn.delegate = self
        rightBtn.delegate = self
        
    }
    
    private lazy var editTableView: UITableView = {
        let editTableView = UITableView()
        editTableView.translatesAutoresizingMaskIntoConstraints = false
        editTableView.register(SearchEditTableViewCell.self, forCellReuseIdentifier: SearchEditTableViewCell.identifier)
        editTableView.allowsSelection = true
        editTableView.separatorStyle = .none
        return editTableView
    }()
    
    // 테이블 뷰 구성 메소드
    private func configureTableView() {
        self.editTableView.dataSource = self
        self.editTableView.delegate = self
        self.editTableView.backgroundColor = .white
        self.editTableView.keyboardDismissMode = .onDrag // 테이블 뷰 스크롤시 키보드 내리기
    }
    
    // 셀이 선택 되었을 경우 하단 버튼 UI 변경하는 메소드
    private func changeButtonUI() {
//        print(selectedStoreID.count)
        if selectedStoreID.count > 0 {
            leftBtn.setTitleColor(UIColor.pointBlue, for: .normal)
            leftBtn.setTitle("선택해제", for: .normal)
            
            rightBtn.backgroundColor = UIColor.pointBlue
            rightBtn.setTitleColor(.white, for: .normal)
            rightBtn.setTitle("삭제 \(selectedStoreID.count)", for: .normal)
        } else {
            leftBtn.setTitle("전체선택", for: .normal)
            leftBtn.setTitleColor(UIColor(red: 0.722, green: 0.741, blue: 0.8, alpha: 1), for: .normal)
            
            rightBtn.backgroundColor =  UIColor(red: 0.969, green: 0.973, blue: 0.98, alpha: 1)
            rightBtn.setTitle("삭제", for: .normal)
            rightBtn.setTitleColor(UIColor(red: 0.722, green: 0.741, blue: 0.8, alpha: 1), for: .normal)
        }
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
            titleLabel.font = .systemFont(ofSize: 17)
            titleLabel.text = "검색내역 편집"
            return titleLabel
        }()
        
        leftBtn.backgroundColor = .white
        leftBtn.titleLabel?.font = .systemFont(ofSize: 16)
        leftBtn.setTitle("전체선택", for: .normal)
        leftBtn.setTitleColor(UIColor(red: 0.722, green: 0.741, blue: 0.8, alpha: 1), for: .normal)
        
        rightBtn.backgroundColor =  UIColor(red: 0.969, green: 0.973, blue: 0.98, alpha: 1)
        rightBtn.titleLabel?.font = .systemFont(ofSize: 16)
        rightBtn.setTitle("삭제", for: .normal)
        rightBtn.setTitleColor(UIColor(red: 0.722, green: 0.741, blue: 0.8, alpha: 1), for: .normal)
        
        view.addSubview(customNavigationBar)
        customNavigationBar.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(customNavigationBar.containerView)
        }
        
        customNavigationBar.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.bottom.equalTo(customNavigationBar.containerView).offset(-15)
            $0.leading.equalTo(customNavigationBar.snp.leading).offset(43)
        }
        
        view.addSubview(editTableView)
        editTableView.snp.makeConstraints {
            $0.top.equalTo(customNavigationBar.snp.bottom)
            $0.leading.trailing.bottom.equalTo(safeArea)
        }
        
        view.addSubview(leftBtn)
        leftBtn.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-50)
            $0.leading.equalToSuperview()
            $0.bottom.equalTo(safeArea)
            $0.width.equalTo(self.view.frame.width / 2)
        }
        
        view.addSubview(rightBtn)
        rightBtn.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-50)
            $0.trailing.equalToSuperview()
            $0.bottom.equalTo(safeArea)
            $0.width.equalTo(self.view.frame.width / 2)
        }
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
}

// MARK: - 네비게이션 바 backbutton 프로토콜 구현
extension SearchEditViewController: CustomNavigationBarProtocol {
    func didTapLeftButton() {
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: - 하단 전체선택 버튼, 삭제 버튼 프로토콜 구현
extension SearchEditViewController: EditButtonProtocol {
    func didTapButton(_ sender: EditButton) {
        if sender == leftBtn {
            if selectedStoreID.count == 0 {
                for i in 0..<storageViewModel.latestSearchStore.count {
                    let indexPath = IndexPath(row: i, section: 0)
                    let cell = editTableView.cellForRow(at: indexPath) as! SearchEditTableViewCell
                    cell.cellSeclected = true
                    if let storeID = cell.storeID {
                        selectedStoreID.append(storeID)
                    }
                }
            } else {
                for i in 0..<storageViewModel.latestSearchStore.count {
                    let indexPath = IndexPath(row: i, section: 0)
                    let cell = editTableView.cellForRow(at: indexPath) as! SearchEditTableViewCell
                    cell.cellSeclected = false
                }
                selectedStoreID.removeAll()
            }
        } else {
            storageViewModel.deleteLatestSearchStore(store: selectedStoreID)
            for id in selectedStoreID {
                if let firstIndex = selectedStoreID.firstIndex(where: {$0 == id}) {
                    selectedStoreID.remove(at: firstIndex)
                }
            }
        }
        changeButtonUI()
        editTableView.reloadData()
    }
}

// MARK: - 테이블 뷰 데이터 소스, 델리게이트 설정
extension SearchEditViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        storageViewModel.latestSearchStore.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchEditTableViewCell.identifier, for: indexPath) as! SearchEditTableViewCell
        let storeInfo = storageViewModel.latestSearchStore[indexPath.row]
        cell.selectionStyle = .none
        cell.backgroundColor = .white
        
        if let store = StoreModel.lists.first(where: {$0.title == storeInfo.storeCategory}) {
            cell.img.image = StoreModel.lists.first(where: {$0.title == storeInfo.storeCategory}) == nil ? UIImage(named: "etc") : UIImage(named: store.id)
        } else {
            cell.img.image = UIImage(named: "etc")
        }
        
        cell.label.text = storeInfo.placeName
        cell.index = indexPath
        cell.storeID = storeInfo.storeID
        cell.isUserInteractionEnabled = true
        
        return cell
    }
    
    // 테이블 뷰 셀의 높이
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 54
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? SearchEditTableViewCell else { return }
        cell.cellSeclected.toggle()
        
        if let selectedIndex = selectedStoreID.firstIndex(where: {$0 == cell.storeID ?? ""}) {
            selectedStoreID.remove(at: selectedIndex)
        }
        if cell.cellSeclected {
            guard let storeID = cell.storeID else { return }
            selectedStoreID.append(storeID)
        }

        changeButtonUI()
    }
}
