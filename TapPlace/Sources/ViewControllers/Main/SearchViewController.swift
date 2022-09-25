//
//  SearchingViewController.swift
//  TapPlace
//
//  Created by 이상준 on 2022/08/14.
//

import SnapKit
import UIKit
import Alamofire
import CoreLocation


// MARK: - 검색화면
class SearchViewController: CommonViewController {
    private var searchListVM: SearchListViewModel!
    
    // 검색 필드 활성화 여부
    var searchMode: Bool = false
    
    // 즐겨찾기 매장을 클릭했는가?
    var isBookmarkTap: Bool = false
    
    // MainVC 플로팅 버튼 클릭 여부
    var isClickFloatingButton: Bool = false
    
    // 중복 실행 막기
    var isLoading: Bool = false
    
    // 카카오 지도 검색 페이지
    var isPaging: Int = 1
    var isEndPage: Bool = false
    
    // 검색 결과 저장할 배열
    var searchResult: [SearchModel] = []
    
    let customNavigationBar = CustomNavigationBar()// 커스텀 네비게이션 바
    let searchField = UITextField()  // 검색 필드
    let recentSearchButton = SearchContentButton() // 최근 검색어 버튼
    let favoriteSearchButton = SearchContentButton() // 즐겨찾는 가맹점 버튼
    var editButton = UIButton()
    var bottomView = UIView()
    var emptyView = UIView()
    var descLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        configureTableView()
        setLayout()
        
        customNavigationBar.delegate = self
        customNavigationBar.isDrawShadow = true
        customNavigationBar.isDrawBottomLine = true
        customNavigationBar.titleText = ""
        customNavigationBar.isUseLeftButton = true
        
        searchField.delegate = self
        searchField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    // 검색 테이블 뷰
    private lazy var searchTableView: UITableView = {
        let searchTableView = UITableView()
        searchTableView.translatesAutoresizingMaskIntoConstraints = false
        searchTableView.register(SearchHistoryTableViewCell.self, forCellReuseIdentifier: SearchHistoryTableViewCell.identifier)
        searchTableView.register(SearchingTableViewCell.self, forCellReuseIdentifier: SearchingTableViewCell.identifier)
        searchTableView.separatorStyle = .none
        searchTableView.allowsSelection = true
        return searchTableView
    }()
    
    // 테이블 뷰 구성
    private func configureTableView() {
        self.searchTableView.dataSource = self
        self.searchTableView.delegate = self
        self.searchTableView.backgroundColor = .white
        self.searchTableView.keyboardDismissMode = .onDrag // 테이블 뷰 스크롤시 키보드 내리기
    }
    
    // 검색시 텍스트 필드 입력 문자만 SearchingTableViewCell 라벨 생상 변경
    func keywordColorChange(label: UILabel) {
        let attributedString = NSMutableAttributedString(string: label.text!)
        attributedString.addAttribute(.foregroundColor, value: UIColor.init(hex: 0x4E77FB), range: (label.text! as NSString).range(of: searchField.text!))
        label.attributedText = attributedString
    }
    
    // 텍스트 필드에 값을 입력했을 경우 이벤트
    @objc func textFieldDidChange(_ sender: UITextField) {
        if sender.text == "" {
            searchMode = false
            searchTableView.snp.remakeConstraints {
                $0.top.equalTo(bottomView.snp.bottom)
                $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
            }
            DispatchQueue.main.async {
                self.searchTableView.reloadData()
            }
        } else {
            searchMode = true
            searchTableView.snp.remakeConstraints {
                $0.top.equalTo(customNavigationBar.snp.bottom)
                $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
            }
        }
        isEndPage = false
        isPaging = 1
        searchResult.removeAll()
        requestPlace()
    }
    
    func requestPlace() {
        // 카카오 검색 API 파라미터
        let parameter: [String: Any] = [
            "query": searchField.text ?? "",
            "x": "\(UserInfo.userLocation?.longitude ?? 0)",
            "y": "\(UserInfo.userLocation?.latitude ?? 0)",
            "page": isPaging
        ]
        
        // 카카오 검색 API 통신 사용
        SearchService().getPlace(parameter: parameter) { (result, error) in
             print("*** isPaging: \(self.isPaging)")
            if let error = error {
//                print("*** 에러가 발생했고 이제 튕길거야!!! 그만해, 이러다 다 튕겨!!! \(error)")
                return
            }
            if let result = result {
                if result.documents.isEmpty { return }
                self.searchResult += result.documents
                self.isEndPage = result.meta.isEnd
            }
            
            DispatchQueue.main.async {
                self.searchTableView.reloadData()
            }
        }
    }
}

// MARK: - 최근 검색어, 즐겨찾는 가맹점 버튼 클릭시 UI 변경 이벤트
extension SearchViewController: SearchContentButtonProtocol {
    func didTapButton(_ sender: SearchContentButton) {
        if sender.tag == 1 {
            self.recentSearchButton.titleLabel?.font = UIFont.systemFont(ofSize: CommonUtils.resizeFontSize(size: 16))
            self.recentSearchButton.setTitleColor(.black, for: .normal)
            self.favoriteSearchButton.titleLabel?.font = UIFont.systemFont(ofSize: CommonUtils.resizeFontSize(size: 14))
            self.favoriteSearchButton.setTitleColor(UIColor(red: 0, green: 0, blue: 0, alpha: 0.3), for: .normal)
            isBookmarkTap = false
            editButton.isHidden = false
        } else {
            self.recentSearchButton.titleLabel?.font = UIFont.systemFont(ofSize: CommonUtils.resizeFontSize(size: 14))
            self.recentSearchButton.setTitleColor(UIColor(red: 0, green: 0, blue: 0, alpha: 0.3), for: .normal)
            self.favoriteSearchButton.titleLabel?.font = UIFont.systemFont(ofSize: CommonUtils.resizeFontSize(size: 16))
            self.favoriteSearchButton.setTitleColor(.black, for: .normal)
            isBookmarkTap = true
            editButton.isHidden = true
        }
        searchTableView.reloadData()
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
        tabBar?.hideTabBar(hide: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 탭바
        tabBar?.hideTabBar(hide: true)
        searchTableView.reloadData()
    }
    
    // 레이아웃 구성
    private func setLayout() {
        let safeArea = view.safeAreaLayoutGuide
        
        searchField.font = .systemFont(ofSize: CommonUtils.resizeFontSize(size: 16), weight: .medium)
        if isClickFloatingButton {
            searchField.placeholder = "등록하려는 가맹점을 입력하세요."
        } else {
            searchField.placeholder = "검색어를 입력하세요."
        }
        searchField.clearButtonMode = .always
    
        
        // 하단 뷰
        bottomView = {
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
        
        descLabel = {
            let descLabel = UILabel()
            descLabel.sizeToFit()
            descLabel.textAlignment = .center
            descLabel.font = .systemFont(ofSize: CommonUtils.resizeFontSize(size: 14), weight: .regular)
            return descLabel
        }()
        
        
        // 편집 버튼
        editButton = {
            let editButton = UIButton()  // 편집 버튼
            editButton.setTitle("편집", for: .normal)
            editButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            editButton.setTitleColor(UIColor(red: 0, green: 0, blue: 0, alpha: 0.5), for: .normal)
            editButton.addTarget(self, action: #selector(moveSearchEditVC(_:)), for: .touchUpInside)
            return editButton
        }()
        
        
        // 상단 뷰 AutoLayout
        view.addSubview(customNavigationBar)
        customNavigationBar.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(customNavigationBar.containerView)
        }
        
        // 검색 텍스트필드 AutoLayout
        customNavigationBar.addSubview(searchField)
        searchField.snp.makeConstraints {
            $0.bottom.equalTo(customNavigationBar.containerView).offset(-15)
            $0.leading.equalTo(customNavigationBar.snp.leading).offset(40)
            $0.trailing.equalTo(customNavigationBar.snp.trailing).offset(-20)
        }

        
        // 하단 뷰 AutoLayout (최근 검색어, 즐겨찾는 가맹점)
        view.addSubview(bottomView)
        bottomView.snp.makeConstraints {
            $0.top.equalTo(customNavigationBar.snp.bottom)
            $0.leading.trailing.equalToSuperview()
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
            $0.leading.trailing.bottom.equalTo(safeArea)
        }
        
        
        view.addSubview(emptyView)
        emptyView.addSubview(descLabel)
        emptyView.snp.remakeConstraints {
            $0.top.equalTo(customNavigationBar.snp.bottom).offset(60)
            $0.leading.trailing.equalTo(customNavigationBar)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        descLabel.snp.makeConstraints {
            $0.edges.equalTo(emptyView)
        }
    }
    
    func showEmptyView(show: Bool, text: String) {
        if show {
            descLabel.text = text
            emptyView.isHidden = false
        } else {
            emptyView.isHidden = true
            
        }
    }
    
    // 편집 버튼 클릭시 편집 화면으로 이동
    @objc func moveSearchEditVC(_ sender: UIButton) {
        let vc = SearchEditViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - 테이블 뷰 셀에 대한 설정
extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    // 셀의 높이
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1 {
            return 0
        }
        
        switch self.searchMode {
        case false:
            return isBookmarkTap ? 72 : 54
        case true:
            return 72
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 {
            return 0
        }
        
        switch self.searchMode {
        case false:
            if isBookmarkTap {
                showEmptyView(show: storageViewModel.numberOfBookmark <= 0, text: "즐겨찾기에 추가한 가맹점이 없어요.")
                return storageViewModel.numberOfBookmark
            } else {
                showEmptyView(show: storageViewModel.latestSearchStore.count <= 0, text: "최근에 검색한 가맹점이 없어요.")
                return storageViewModel.latestSearchStore.count
            }
        case true:
            showEmptyView(show: searchResult.count <= 0, text: "인근에 검색한 가맹점이 없어요.")
            return searchResult.count
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
     
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 1 {
            return UITableViewCell()
        }
        
        switch self.searchMode {
        case false:
            if isBookmarkTap {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchingTableViewCell.identifier, for: indexPath) as? SearchingTableViewCell else { fatalError("no matched articleTableViewCell identifier") }
                let bookmarkStore = storageViewModel.bookmarkDataSource[indexPath.row]
                // 카테고리 이미지
                var categoryName = "etc"
                if let categoryGroupCode = StoreModel.lists.first(where: {$0.title == bookmarkStore.storeCategory}) {
                    categoryName = categoryGroupCode.id
                }
                // 매장 거리
                var storeDistance = "0m"
                let userLocation = UserInfo.userLocation
                if let userLocation = userLocation {
                    let storeLocation = CLLocationCoordinate2D(latitude: Double(bookmarkStore.locationY), longitude: Double(bookmarkStore.locationX))
                    let userStoreDistance = userLocation.distance(from: storeLocation)
                    storeDistance = DistancelModel.getDistance(distance: userStoreDistance)
                }
                cell.prepare(categoryGroupCode: categoryName, placeName: bookmarkStore.placeName, distance: storeDistance, roadAddress: bookmarkStore.roadAddressName, address: bookmarkStore.addressName)
                cell.selectionStyle = .none
                return cell
            } else {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchHistoryTableViewCell.identifier, for: indexPath) as? SearchHistoryTableViewCell else { fatalError("no matched articleTableViewCell identifier") }
                cell.selectionStyle = .none
                cell.backgroundColor = .white
                let latestSearch = storageViewModel.latestSearchStore[indexPath.row]
                cell.storeCategory = latestSearch.storeCategory
                cell.label.text = latestSearch.placeName
                cell.storeInfo = latestSearch.convertStoreInfo()
                cell.deleteButton.setImage(UIImage(systemName: "xmark"), for: .normal)
                cell.index = indexPath
                cell.delegate = self
                return cell
            }
            
        case true:
            if searchResult.isEmpty {
//                print("*** 검색결과 데이터에 아무것도 없기 때문에 오류 방지를 위해 빈 셀을 반환합니다.")
                return UITableViewCell()
            }
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchingTableViewCell.identifier, for: indexPath) as? SearchingTableViewCell else { fatalError("no matched articleTableViewCell identifier") }
            cell.selectionStyle = .none
//            print("***searchResult: \(searchResult)")
            let searchVM = searchResult[indexPath.row]
            let storeDistance = DistancelModel.getDistance(distance: (Double(searchVM.distance ?? "0") ?? 0) / 1000)
            
            cell.prepare(categoryGroupCode: searchVM.categoryGroupCode, placeName: searchVM.placeName, distance: storeDistance, roadAddress: searchVM.roadAddressName, address: searchVM.addressName)
            self.keywordColorChange(label: cell.placeNameLbl)
            return cell
        }
    } 
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isLoading { return }
        isLoading = true
        switch self.searchMode {
        case true: // 검색중일때
            let searchModelEach = searchResult[indexPath.row]
            if StoreModel.lists.first(where: {$0.id == searchModelEach.categoryGroupCode }) == nil {
                showToast(message: "지원하지 않는 가맹점입니다.", view: self.view)
                isLoading = false
                return
            }
            // FIXME: MVVM 수정
            storeViewModel.requestStoreInfoCheck(searchModel: searchModelEach, pays: storageViewModel.userFavoritePaymentsString) { result in
                if let result = result {
                    let storeInfo = SearchModel.convertStoreInfo(searchModel: searchModelEach)
                    if self.isClickFloatingButton {
                        // 플로팅 버튼을 눌러서 접근했을 때
                        if result == nil {
                            showToast(message: "알 수 없는 이유로 가맹점 정보를 불러오지 못했습니다.\n잠시 후 다시 시도해주시기 바랍니다.", view: self.view)
                            return
                        }
                        let storeDatailVC = StoreDetailViewController()
                        var targetStoreInfo = storeInfo
                        targetStoreInfo.feedback = result
                        storeDatailVC.storeInfo = targetStoreInfo
                        self.navigationController?.pushViewController(storeDatailVC, animated: true)
                    } else {
                        // 검색창을 눌러서 접근했을 떄
                        let mainVC = MainViewController()
                        mainVC.storeInfo = storeInfo
                        mainVC.isMainMode = false
                        self.navigationController?.pushViewController(mainVC, animated: true)
                    }
                }
                self.isLoading = false
            }
            let latestSearchStore = LatestSearchStore(storeID: searchModelEach.id, placeName: searchModelEach.placeName, locationX: Double(searchModelEach.x) ?? 0, locationY: Double(searchModelEach.y) ?? 0, addressName: searchModelEach.addressName, roadAddressName: searchModelEach.roadAddressName, storeCategory: searchModelEach.categoryGroupName, phone: searchModelEach.phone, date: Date().getDate(3))
                storageViewModel.addLatestSearchStore(store: latestSearchStore )
        case false:
            let storeDetailVC = StoreDetailViewController()
            var searchModelEach: SearchModel?
            var storeID = ""
            if isBookmarkTap {
                var tempDataSource = storageViewModel.bookmarkDataSource[indexPath.row]
                searchModelEach = SearchModel(addressName: tempDataSource.addressName, categoryGroupCode: "", categoryGroupName: tempDataSource.storeCategory, distance: "", id: tempDataSource.storeID, phone: "", placeName: tempDataSource.placeName, placeURL: "", roadAddressName: tempDataSource.roadAddressName, x: "\(tempDataSource.locationX)", y: "\(tempDataSource.locationY)")
                storeID = tempDataSource.storeID
            } else {
                var tempDataSource = storageViewModel.latestSearchStore[indexPath.row]
                searchModelEach = SearchModel(addressName: tempDataSource.addressName, categoryGroupCode: "", categoryGroupName: tempDataSource.storeCategory, distance: "", id: tempDataSource.storeID, phone: tempDataSource.phone, placeName: tempDataSource.placeName, placeURL: "", roadAddressName: tempDataSource.roadAddressName, x: "\(tempDataSource.locationX)", y: "\(tempDataSource.locationY)")
                storeID = tempDataSource.storeID
            }
            
            // 가맹점 상세창에서 받아야 할 데이터
            storeDetailVC.storeID = storeID
            
            guard let searchModelEach = searchModelEach else { return }
            // FIXME: MVVM 수정
            if StoreModel.lists.first(where: {$0.title == searchModelEach.categoryGroupName }) == nil {
                print(searchModelEach)
                showToast(message: "지원하지 않는 가맹점입니다.", view: self.view)
                isLoading = false
                return
            }
            storeViewModel.requestStoreInfoCheck(searchModel: searchModelEach, pays: storageViewModel.userFavoritePaymentsString) { result in
                if let result = result {
                    var storeInfo = SearchModel.convertStoreInfo(searchModel: searchModelEach)
                    storeInfo.feedback = result
                    storeDetailVC.storeInfo = storeInfo
                    self.navigationController?.pushViewController(storeDetailVC, animated: true)
                } else {
                    showToast(message: "알 수 없는 오류가 발생했습니다.\n잠시후 다시 시도해주시기 바랍니다.", view: self.view)
                }
                self.isLoading = false
            }
        }
    }
    
    //MARK: 검색결과 더보기 버튼을 위한 푸터뷰
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section != 1 || !searchMode { return .zero }
        return 50
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section != 1 { return nil }
        if isEndPage { return nil }
        
        
        let footerView = UIView()
        let expendButton = TableViewExpendButton(type: .system)
        expendButton.setTitle("검색결과 더보기", for: .normal)
        footerView.addSubview(expendButton)
        expendButton.snp.makeConstraints {
            $0.edges.equalTo(footerView)
        }
        expendButton.addTarget(self, action: #selector(didTapExpendButton), for: .touchUpInside)
        return footerView
    }
    /**
     * @검색결과 더보기 버튼 클릭 함수
     * coder : sanghyeon
     */
    @objc func didTapExpendButton() {
        if isEndPage {
            showToast(message: "마지막 검색 결과 입니다.", view: self.view)
        } else {
            isPaging += 1
            requestPlace()
        }
    }
    
}

// MARK: - 네비게이션 바 backbutton 프로토콜 구현
extension SearchViewController: CustomNavigationBarProtocol {
    func didTapLeftButton() {
        self.navigationController?.popViewController(animated: true)
    }
}


// MARK: - 최근 검색어 삭제
extension SearchViewController: XBtnProtocol { 
    func deleteCell(storeID: String) {
        storageViewModel.deleteLatestSearchStore(store: storeID)
        self.searchTableView.reloadData()
    }
}

// MARK: - 검색 텍스트 필드 Delegeate
extension SearchViewController: UITextFieldDelegate {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder() // 키보드에서 Reuturn 클릭시 TextField 비활성화
        return true
    }
}
