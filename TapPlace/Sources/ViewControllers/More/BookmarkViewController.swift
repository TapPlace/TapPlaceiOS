//
//  BookmarkViewController.swift
//  TapPlace
//
//  Created by 박상현 on 2022/09/06.
//

import UIKit
import Combine
 
class BookmarkViewController: CommonViewController {
    
    let customNavigationBar = CustomNavigationBar()
    let navigationRightButton = UIButton(type: .system)
    let filterTitle = MoreListFilterTitle()
    var tableView = UITableView()
    let allSelectButton = BottomButton()
    let deleteButton = BottomButton()

    var filterAsc: Bool = false
    var isEditMode: Bool = false
    var isPage: Int = 0
    var isEnd: Bool = false
    var isLoading: Bool = false
    
    var bookmarkDataSource: [Bookmark] = []
    var subscription = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBindings()
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
     * @ 북마크 뷰모델 바인딩
     * coder : sanghyeon
     */
    func setBindings() {
        bookmarkViewModel.$dataSource.sink { (bookmarks: [Bookmark]?) in
            print("*** BookmarkVC, BookmarkVM dataSource 데이터 변경됨")
            if let bookmarks = bookmarks {
                /// 기존 데이터와 같다면 별도의 처리를 하지 않음
                //if self.bookmarkDataSource.count > 0 && self.bookmarkDataSource[0].num == bookmarks[0].num { return }
                self.bookmarkDataSource += bookmarks
                self.filterTitle.filterCount = self.bookmarkDataSource.count
                self.isEnd = self.bookmarkViewModel.isEnd
                self.isLoading = false
                self.isPage += 1
                self.tableView.reloadData()
            }
        }.store(in: &subscription)
    }
    /**
     * @ 북마크 불러오기
     * coder : sanghyeon
     */
    func loadBookmarks() {
        if isEnd || isLoading { return }
        isLoading = true
        bookmarkViewModel.requestBookmark(page: isPage, containFeedback: true)
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
        //tableView.register(AroundStoreTableViewCell.self, forCellReuseIdentifier: AroundStoreTableViewCell.cellId)
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
            
            
        }
    }
    @objc func didTapAllSelectButton() {
        let checkedBookmark = bookmarkDataSource.filter { $0.isChecked == true }
        selectBookmark(allSelect: self.bookmarkDataSource.count == checkedBookmark.count ? false : true)
    }
    @objc func didTapDeleteButton() {
//        print("삭제 버튼 탭")
        if !deleteButton.isActive { return }
        deleteBookmark()
        
    }
}
//MARK: - TableView
extension BookmarkViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.bookmarkDataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BookMarkEditModeCell.cellId, for: indexPath) as? BookMarkEditModeCell else { return UITableViewCell() }
        cell.cellIndex = indexPath.row
        // FIXME: MVVM 수정
        cell.storeInfo = self.bookmarkDataSource[indexPath.row].convertStoreInfo()
        if let bookmarkChecked = bookmarkDataSource[indexPath.row].isChecked {
            cell.cellSelected = bookmarkChecked
        }
        cell.selectionStyle = .none
        cell.isEditMode = isEditMode
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isEditMode {
            selectBookmark(indexPath: indexPath)
        } else {
            let vc = StoreDetailViewController()
            let bookmarkStore = self.bookmarkDataSource[indexPath.row]
            vc.storeInfo = bookmarkStore.convertStoreInfo()
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    /**
     * @ 즐겨찾기 가맹점 선택
     * coder : sanghyeon
     */
    func selectBookmark(indexPath: IndexPath? = nil, allSelect: Bool? = nil) {
        if !isEditMode { return }
        
        if let allSelect = allSelect {
            // FIXME: 인덱스 오류 확인
            for i in 0 ... bookmarkDataSource.count - 1 {
                var bookmark = bookmarkDataSource[i]
                bookmark.isChecked = allSelect
                bookmarkDataSource[i] = bookmark
            }
            tableView.reloadData()
        } else {
            guard let indexPath = indexPath else { return }
            var checkedBookmark = bookmarkDataSource[indexPath.row]
            checkedBookmark.isChecked?.toggle()
            bookmarkDataSource[indexPath.row] = checkedBookmark
        }
        tableView.reloadData()
        updateButtonState()
    }
    
    /**
     * @ 버튼 업데이트
     * coder : sanghyeon
     */
    func updateButtonState() {
        let checkedCount = bookmarkDataSource.filter {$0.isChecked == true}.count
        //let deleteCount: String = checkedCellIndex.count > 0 ? " \(checkedCellIndex.count)" : ""
        
        deleteButton.setButtonStyle(title: "삭제\(checkedCount)", type: checkedCount > 0 ? .activate : .disabled, fill: true)
        deleteButton.isActive = checkedCount > 0
        
        allSelectButton.setButtonStyle(title: checkedCount == self.bookmarkDataSource.count ? "선택해제" : "전체선택", type: .activate, fill: true)
    }
    
    /**
     * @ 즐겨찾기 삭제
     * coder : sanghyeon
     */
    func deleteBookmark() {
        let checkedBookmark = bookmarkDataSource.filter { $0.isChecked == true }
        checkedBookmark.forEach { bookmark in
            bookmarkViewModel.requestToggleBookmark(currentBookmark: false, storeID: bookmark.storeID) { result in
                if let result = result {
                    if result {
                        if self.bookmarkDataSource.count <= 0 {
                            self.didTapFilterEditButton()
                        }
                        self.selectBookmark(allSelect: false)
                        if let targetIndex = self.bookmarkDataSource.firstIndex(where: { $0.storeID == bookmark.storeID }) {
                            self.bookmarkDataSource.remove(at: targetIndex)
                        }
                    }
                }
                self.filterTitle.filterCount = self.bookmarkDataSource.count
                self.selectBookmark(allSelect: false)
                self.tableView.reloadData()
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
