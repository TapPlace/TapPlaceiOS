//
//  SearchingViewController.swift
//  TapPlace
//
//  Created by 이상준 on 2022/08/14.
//

import Foundation
import SnapKit
import UIKit
import Alamofire
import CoreLocation


// MARK: - 검색화면
class SearchViewController: CommonViewController {
    
    // 더미 데이터
    var searchingData = ["세븐 일레븐 등촌 3호점", "BBQ 등촌행복점", "세븐 일레븐 등촌 3호점", "BBQ 등촌행복점"]
    var img = [
        UIImage(systemName: "fork.knife.circle.fill"),
        UIImage(systemName: "fork.knife.circle.fill"),
        UIImage(systemName: "fork.knife.circle.fill"),
        UIImage(systemName: "fork.knife.circle.fill")
    ]
    
    private var searchListVM: SearchListViewModel!
    
    // 검색 필드 활성화 여부
    var searchMode: Bool = false
    
    // 즐겨찾기 매장을 클릭했는가?
    var isBookmarkTap: Bool = false
    
    // MainVC 플로팅 버튼 클릭 여부
    var isClickFloatingButton: Bool? = false
    
    let customNavigationBar = CustomNavigationBar()// 커스텀 네비게이션 바
    let searchField = UITextField()  // 검색 필드
    let recentSearchButton = SearchContentButton() // 최근 검색어 버튼
    let favoriteSearchButton = SearchContentButton() // 즐겨찾는 가맹점 버튼
    var editButton = UIButton()
    var bottomView = UIView()
    
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
        
        // 카카오 검색 API 파라미터
        let parameter: [String: Any] = [
            "query": searchField.text!,
            "x": "\(UserInfo.userLocation?.longitude ?? 0)",
            "y": "\(UserInfo.userLocation?.latitude ?? 0)",
            "radius": 1000,
            "sort" : "distance" // 거리순으로 정렬
        ]
        
        // 카카오 검색 API 통신 사용
        SearchService().getPlace(parameter: parameter) { (documents) in
            if let documents = documents {
                self.searchListVM = SearchListViewModel(documents: documents)
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
//        print("뷰 사라집니다.")
        tabBar?.showTabBar(hide: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 탭바
//        print("뷰 나타납니다.")
        tabBar?.showTabBar(hide: true)
        searchTableView.reloadData()
    }
    
    // 레이아웃 구성
    private func setLayout() {
        let safeArea = view.safeAreaLayoutGuide
        
        searchField.font = UIFont(name: "AppleSDGothicNeoM00", size: 16)
        searchField.placeholder = "등록하려는 가맹점을 찾아보세요."
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
        switch self.searchMode {
        case false:
            return isBookmarkTap ? 72 : 54
        case true:
            return 72
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch self.searchMode {
        case false:
            if isBookmarkTap {
                return storageViewModel.numberOfBookmark
            } else {
                return storageViewModel.latestSearchStore.count
            }
        case true:
            return self.searchListVM.numberOfRowsInSection(1)
        }
    }
     
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchingTableViewCell.identifier, for: indexPath) as? SearchingTableViewCell else { fatalError("no matched articleTableViewCell identifier") }
            cell.selectionStyle = .none
            let searchVM = self.searchListVM.searchAtIndex(indexPath.row)
            
            cell.prepare(categoryGroupCode: searchVM.categoryGroupCode, placeName: searchVM.placeName, distance: searchVM.distance, roadAddress: searchVM.roadAddressName, address: searchVM.addressName)
            self.keywordColorChange(label: cell.placeNameLbl)
            return cell
        }
    } 
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch self.searchMode {
        case true:
            let searchVM: SearchViewModel = self.searchListVM.searchAtIndex(indexPath.row)
            if isClickFloatingButton == true {
                let feedbackRequestVC = FeedbackRequestViewController()
//                feedbackRequestVC.storeId = searchVM.storeID
                self.navigationController?.pushViewController(feedbackRequestVC, animated: true)
            } else {
                // 가맹점 상세창에서 받아야 할 데이터
                let storeDetailVC = StoreDetailViewController()
                storeDetailVC.storeID = searchVM.storeID
                guard let searchModelEach = searchVM.searchModelEach else { return }
                storeViewModel.requestStoreInfoCheck(searchModel: searchModelEach, pays: storageViewModel.userFavoritePaymentsString) { result in
                    if let result = result {
                        var storeInfo = SearchModel.convertStoreInfo(searchModel: searchModelEach)
                        storeInfo.feedback = result
                        storeDetailVC.storeInfo = storeInfo
                        self.navigationController?.pushViewController(storeDetailVC, animated: true)
                    } else {
                        showToast(message: "알 수 없는 오류가 발생했습니다.\n잠시후 다시 시도해주시기 바랍니다.", view: self.view)
                    }
                }
            }
            if let storeID = searchVM.storeID,
                let placeName = searchVM.placeName,
                let x = searchVM.locationX,
                let y = searchVM.locationY,
                let addressName = searchVM.addressName,
                let roadAddressName = searchVM.roadAddressName,
                let storeCategory = searchVM.categortGroupName {
                let latestSearchStore = LatestSearchStore(storeID: storeID, placeName: placeName, locationX: Double(x) ?? 0, locationY: Double(y) ?? 0, addressName: addressName, roadAddressName: roadAddressName, storeCategory: storeCategory, phone: "", date: Date().getDate(3))
                storageViewModel.addLatestSearchStore(store: latestSearchStore )
            }
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
            storeViewModel.requestStoreInfoCheck(searchModel: searchModelEach, pays: storageViewModel.userFavoritePaymentsString) { result in
                if let result = result {
                    var storeInfo = SearchModel.convertStoreInfo(searchModel: searchModelEach)
                    storeInfo.feedback = result
                    storeDetailVC.storeInfo = storeInfo
                    self.navigationController?.pushViewController(storeDetailVC, animated: true)
                } else {
                    showToast(message: "알 수 없는 오류가 발생했습니다.\n잠시후 다시 시도해주시기 바랍니다.", view: self.view)
                }
            }
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
