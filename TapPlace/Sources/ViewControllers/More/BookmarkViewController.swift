//
//  BookmarkViewController.swift
//  TapPlace
//
//  Created by 박상현 on 2022/09/06.
//

import UIKit
 
class BookmarkViewController: CommonViewController {
    
    let customNavigationBar = CustomNavigationBar()
    let navigationRightButton = UIButton(type: .system)
    let filterTitle = MoreListFilterTitle()
    var tableView = UITableView()
    let allSelectButton = BottomButton()
    let deleteButton = BottomButton()

    var filterAsc: Bool = false
    var isEditMode: Bool = false
    var isPage: Int = 1
    var isEnd: Bool = false
    var isLoading: Bool = false
    
    var checkedCellIndex: [Int] = []
    
    var bookmarkDataSource: [Bookmark] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        setupView()
        loadBookmarks()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBar?.hideTabBar(hide: true)
        tabBar?.isShowFloatingButton = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBar?.hideTabBar(hide: false)
        tabBar?.isShowFloatingButton = true
    }
}

extension BookmarkViewController: CustomNavigationBarProtocol, FilterTitleProtocol {
    /**
     * @ 북마크 불러오기
     * coder : sanghyeon
     */
    func loadBookmarks() {
        if isEnd || isLoading { return }
        isLoading = true
        bookmarkViewModel.requestBookmark(page: isPage) { result, error in
            if let _ = error {
                showToast(message: "알 수 없는 이유로 즐겨찾는 매장을 불러오지 못했습니다.\n잠시 후, 다시 시도해주시기 바랍니다.", view: self.view)
            }
            if let result = result {
                self.isEnd = result.isEnd
                if !result.isEnd {
                    self.isPage += 1
                }
                guard let bookmarks = result.bookmarks else { return }
                bookmarks.forEach {
                    self.bookmarkDataSource.append($0)
                }
                
                self.filterTitle.filterCount = self.bookmarkDataSource.count
                self.tableView.reloadData()
                self.isLoading = false
            }
        }
    }
    /**
     * @ 초기 레이아웃 설정
     * coder : sanghyeon
     */
    func setupView() {
        //MARK: ViewDefine
        let safeArea = view.safeAreaLayoutGuide
        let storeTableView: UITableView = {
            let storeTableView = UITableView()
            storeTableView.rowHeight = 110
            storeTableView.separatorInset = .zero
            return storeTableView
        }()
        tableView = storeTableView
        
        
        //MARK: ViewPropertyManual
        self.view.backgroundColor = .white
        filterTitle.setFilterName = "등록순"
        filterTitle.filterName = "가맹점"
        filterTitle.filterCount = self.bookmarkDataSource.count
        
        
        //MARK: AddSubView
        self.view.addSubview(customNavigationBar)
        customNavigationBar.addSubview(navigationRightButton)
        self.view.addSubview(filterTitle)
        
        
        //MARK: ViewContraints
        customNavigationBar.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(customNavigationBar.containerView)
        }
        navigationRightButton.snp.makeConstraints {
            $0.trailing.equalTo(customNavigationBar).offset(-20)
            $0.centerY.equalTo(customNavigationBar.navigationTitleLabel)
        }
        filterTitle.snp.makeConstraints {
            $0.top.equalTo(customNavigationBar.snp.bottom)
            $0.leading.trailing.equalTo(safeArea).inset(20)
            $0.height.equalTo(50)
        }
        
        
        //MARK: ViewAddTarget
        
        
        //MARK: Delegate
        customNavigationBar.delegate = self
        filterTitle.delegate = self
        
        
        //MARK: TableView
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.leading.trailing.equalTo(safeArea).inset(20)
            $0.bottom.equalTo(safeArea)
            $0.top.equalTo(filterTitle.snp.bottom)
        }
        tableView.register(AroundStoreTableViewCell.self, forCellReuseIdentifier: AroundStoreTableViewCell.cellId)
        tableView.register(BookMarkEditModeCell.self, forCellReuseIdentifier: BookMarkEditModeCell.cellId)
        
    }
    /**
     * @ 네비게이션 속성 세팅
     * coder : sanghyeon
     */
    func setupNavigation() {
        customNavigationBar.titleText = "즐겨찾기"
        customNavigationBar.isUseLeftButton = true
        
        /// 네비게이션 우측 버튼
        navigationRightButton.setTitle("지도보기", for: .normal)
        navigationRightButton.tintColor = .pointBlue
        navigationRightButton.addTarget(self, action: #selector(didTapNavigationRightButton), for: .touchUpInside)
        navigationRightButton.isHidden = true
    }
    /**
     * @ 네비게이션 좌측 버튼 클릭 함수
     * coder : sanghyeon
     */
    func didTapLeftButton() {
        self.navigationController?.popViewController(animated: true)
    }
    /**
     * @ 네비게이션 우측 버튼 클릭 함수
     * coder : sanghyeon
     */
    @objc func didTapNavigationRightButton() {
//        print("네비게이션 우측 버튼 탭")
    }
    /**
     * @ 필터 정렬 버튼 클릭 함수
     * coder : sanghyeon
     */
    func didTapFilterSortButton() {
        self.filterAsc.toggle()
        if filterAsc {
            filterTitle.filterButtonSetImage = "chevron.up"
        } else {
            filterTitle.filterButtonSetImage = "chevron.down"
        }
    }
    /**
     * @ 필터 편집 버튼 클릭 함수
     * coder : sanghyeon
     */
    func didTapFilterEditButton() {
//        if self.dataSource.count <= 0 { return }
        let safeArea = self.view.safeAreaLayoutGuide
        
        self.isEditMode.toggle()
        tableView.reloadData()
        
        if self.isEditMode {
            allSelectButton.addTarget(self, action: #selector(didTapAllSelectButton), for: .touchUpInside)
            deleteButton.addTarget(self, action: #selector(didTapDeleteButton), for: .touchUpInside)

            self.view.addSubview(allSelectButton)
            self.view.addSubview(deleteButton)
            
            allSelectButton.setButtonStyle(title: "전체선택", type: .activate, fill: true)
            deleteButton.setButtonStyle(title: "삭제", type: .disabled, fill: true)
            
            allSelectButton.snp.makeConstraints {
                $0.left.bottom.equalToSuperview()
                $0.top.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-50)
                $0.width.equalTo(self.view.frame.width / 2)
            }
            deleteButton.snp.makeConstraints {
                $0.right.bottom.equalToSuperview()
                $0.top.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-50)
                $0.width.equalTo(self.view.frame.width / 2)
            }
            tableView.snp.remakeConstraints {
                $0.top.equalTo(filterTitle.snp.bottom)
                $0.leading.trailing.equalTo(safeArea).inset(20)
                $0.bottom.equalTo(deleteButton.snp.top)
            }
        } else {
            allSelectButton.removeFromSuperview()
            deleteButton.removeFromSuperview()
            
            tableView.snp.makeConstraints {
                $0.leading.trailing.equalTo(safeArea).inset(20)
                $0.bottom.equalTo(safeArea)
                $0.top.equalTo(filterTitle.snp.bottom)
            }
            
            checkedCellIndex.removeAll()
        }
    }
    @objc func didTapAllSelectButton() {
        selectBookmark(allSelect: self.bookmarkDataSource.count == checkedCellIndex.count ? false : true)
    }
    @objc func didTapDeleteButton() {
//        print("삭제 버튼 탭")
        if !deleteButton.isActive { return }
        deleteBookmark(index: checkedCellIndex)
        
    }
}
//MARK: - TableView
extension BookmarkViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.bookmarkDataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BookMarkEditModeCell.cellId, for: indexPath) as? BookMarkEditModeCell else { return UITableViewCell() }
        let cellDataSource = self.bookmarkDataSource[indexPath.row]
        cell.cellIndex = indexPath.row
        storeViewModel.requestStoreInfo(storeID: cellDataSource.storeID, pays: storageViewModel.userFavoritePaymentsString) { result in
            guard let storeInfo = result else { return }
            cell.storeInfo = storeInfo//AroundStoreModel.convertStoreInfo(storeInfo: storeInfo)
        }
        if let cellChecked = bookmarkDataSource[indexPath.row].isChecked {
            cell.cellSelected = cellChecked
        }
        cell.selectionStyle = .none
        cell.isEditMode = isEditMode
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isEditMode {
            selectBookmark(indexPath: indexPath)
        } else {
            if isLoading { return }
            isLoading = true
            let vc = StoreDetailViewController()
            let bookmarkStore = self.bookmarkDataSource[indexPath.row]
            var tempStore = bookmarkStore.convertStoreInfo()
            storeViewModel.requestStoreInfoCheck(searchModel: bookmarkStore.convertSearchModel(), pays: storageViewModel.userFavoritePaymentsString) { result in
                if let result = result {
                    tempStore.feedback = result
                    vc.storeInfo = tempStore
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                self.isLoading = false
            }
        
        }
    }
    
    /**
     * @ 즐겨찾기 가맹점 선택
     * coder : sanghyeon
     */
    func selectBookmark(indexPath: IndexPath? = nil, allSelect: Bool? = nil) {
        if !isEditMode { return }

        if let allSelect = allSelect {
            print("*** BookmarkVC, selectBookmark\n - allSelect: \(allSelect)\n - self.bookmarkDataSource.count: \(self.bookmarkDataSource.count)")
            checkedCellIndex.removeAll()
            for i in 0...self.bookmarkDataSource.count - 1 {
                let cellIndexPath = IndexPath(row: i, section: 0)
                print("*** BookmarkVC, selectBookmark\n - i: \(i)\n - cellIndexPath: \(cellIndexPath)")
                if let cell = tableView.cellForRow(at: cellIndexPath) as? BookMarkEditModeCell {
                    print("*** BookmarkVC, selectBookmark\n - cell: \(cell)")
                    cell.cellSelected = allSelect
                    bookmarkDataSource[i].isChecked = allSelect
                    switch allSelect {
                    case true:
                        checkedCellIndex.append(i)
                    case false:
                        break
                    }
                }
            }
        } else {
            guard let indexPath = indexPath else { return }
            guard let cell = tableView.cellForRow(at: indexPath) as? BookMarkEditModeCell else { return }
            cell.cellSelected.toggle()
            if cell.cellSelected {
                checkedCellIndex.append(indexPath.row)
                bookmarkDataSource[indexPath.row].isChecked = true
            } else {
                if let index = checkedCellIndex.firstIndex(of: indexPath.row) {
                    checkedCellIndex.remove(at: index)
                    bookmarkDataSource[indexPath.row].isChecked = false
                }
            }
        }
        
//        print("updateButtonState()")
        updateButtonState()
    }
    
    /**
     * @ 버튼 업데이트
     * coder : sanghyeon
     */
    func updateButtonState() {
        let deleteCount: String = checkedCellIndex.count > 0 ? " \(checkedCellIndex.count)" : ""
//        print("deleteCount: \(deleteCount)")
        deleteButton.setButtonStyle(title: "삭제\(deleteCount)", type: checkedCellIndex.count > 0 ? .activate : .disabled, fill: true)
        deleteButton.isActive = checkedCellIndex.count > 0
        
        allSelectButton.setButtonStyle(title: checkedCellIndex.count == self.bookmarkDataSource.count ? "선택해제" : "전체선택", type: .activate, fill: true)
    }
    
    /**
     * @ 즐겨찾기 삭제
     * coder : sanghyeon
     */
    func deleteBookmark(index: [Int]?) {
//        print("isEditMode: \(isEditMode)")
        guard let index = index else { return }
        index.forEach { targetIndex in
            let targetBookmark = self.bookmarkDataSource[targetIndex]
            bookmarkViewModel.requestToggleBookmark(isBookmark: false, storeID: bookmarkDataSource[targetIndex].storeID) { result in
                if let result = result {
                    if result {
                        self.bookmarkDataSource.remove(at: targetIndex)
                        //self.dataSource = storageViewModel.bookmarkDataSource
                        self.checkedCellIndex.removeAll()
                        if self.bookmarkDataSource.count <= 0 {
                            self.didTapFilterEditButton()
                        }
                        self.selectBookmark(allSelect: false)
                        self.filterTitle.filterCount = self.bookmarkDataSource.count
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
}

//MARK: - Scroll
extension BookmarkViewController {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView != tableView { return }
        if tableView.contentOffset.y > tableView.contentSize.height-tableView.bounds.size.height {
            if isLoading || isEnd { return }
            loadBookmarks()
        }
    }
}
