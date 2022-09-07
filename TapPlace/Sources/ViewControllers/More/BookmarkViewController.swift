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
    var selectLabel = UILabel()
    var selectedCountLabel = UILabel()
    
    var filterAsc: Bool = false
    var isEditMode: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        setupView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBar?.isShowFloatingButton = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBar?.isShowFloatingButton = true
    }
}

extension BookmarkViewController: CustomNavigationBarProtocol, FilterTitleProtocol {
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
        tableView.delegate = self
        tableView.dataSource = self
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
    }
    /**
     * @ 네비게이션 좌측 버튼 클릭 함수
     * coder : sanghyeon
     */
    func didTapLeftButton() {
        print("네비게이션 좌측 버튼 탭")
        self.navigationController?.popViewController(animated: true)
    }
    /**
     * @ 네비게이션 우측 버튼 클릭 함수
     * coder : sanghyeon
     */
    @objc func didTapNavigationRightButton() {
        print("네비게이션 우측 버튼 탭")
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
        let safeArea = self.view.safeAreaLayoutGuide
        
        self.isEditMode.toggle()
        tableView.reloadData()
        
        if self.isEditMode {
            selectLabel = {
                let selectLabel = UILabel()
                selectLabel.sizeToFit()
                selectLabel.text = "선택"
                selectLabel.textColor = .black
                selectLabel.font = .systemFont(ofSize: CommonUtils.resizeFontSize(size: 14), weight: .regular)
                return selectLabel
            }()
            selectedCountLabel = {
                let selectedCountLabel = UILabel()
                selectedCountLabel.sizeToFit()
                selectedCountLabel.text = "5"
                selectedCountLabel.textColor = .pointBlue
                selectedCountLabel.font = .systemFont(ofSize: CommonUtils.resizeFontSize(size: 14), weight: .bold)
                return selectedCountLabel
            }()
            
            allSelectButton.addTarget(self, action: #selector(didTapAllSelectButton), for: .touchUpInside)
            deleteButton.addTarget(self, action: #selector(didTapDeleteButton), for: .touchUpInside)
            
            self.view.addSubview(selectLabel)
            self.view.addSubview(selectedCountLabel)
            self.view.addSubview(allSelectButton)
            self.view.addSubview(deleteButton)
            
            allSelectButton.setButtonStyle(title: "전체선택", type: .activate, fill: false)
            deleteButton.setButtonStyle(title: "삭제", type: .disabled, fill: false)
            
            allSelectButton.snp.makeConstraints {
                $0.leading.bottom.equalTo(safeArea)
                $0.height.equalTo(50)
                $0.width.equalTo(self.view.frame.width / 2)
            }
            deleteButton.snp.makeConstraints {
                $0.trailing.bottom.equalTo(safeArea)
                $0.height.equalTo(50)
                $0.width.equalTo(self.view.frame.width / 2)
            }
            selectLabel.snp.makeConstraints {
                $0.leading.equalTo(safeArea).offset(20)
                $0.bottom.equalTo(allSelectButton.snp.top).offset(-10)
            }
            selectedCountLabel.snp.makeConstraints {
                $0.leading.equalTo(selectLabel.snp.trailing).offset(5)
                $0.centerY.equalTo(selectLabel)
            }
            tableView.snp.remakeConstraints {
                $0.top.equalTo(filterTitle.snp.bottom)
                $0.leading.trailing.equalTo(safeArea).inset(20)
                $0.bottom.equalTo(selectLabel.snp.top).offset(-10)
            }
        } else {
            selectLabel.removeFromSuperview()
            selectedCountLabel.removeFromSuperview()
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
        print("전체선택 버튼 탭")
    }
    @objc func didTapDeleteButton() {
        print("삭제 버튼 탭")
    }
}
//MARK: - TableView
extension BookmarkViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BookMarkEditModeCell.cellId, for: indexPath) as? BookMarkEditModeCell else { return UITableViewCell() }
        cell.cellIndex = indexPath.row
        //cell.storeInfoView.setAttributedString(store: "[\(indexPath.row)] 세븐일레븐 염창점", distance: "50m", address: "서울특별시 강서구 양천로 677", isBookmark: bookmark)
        let dummyFeedback = [
            Feedback(num: 0, storeID: "118519786", success: 10, fail: 5, lastState: "success", lastTime: "2022.01.02", pay: "apple_visa", exist: true),
            Feedback(num: 0, storeID: "118519786", success: 10, fail: 5, lastState: "success", lastTime: "2022.01.02", pay: "google_master", exist: true),
            Feedback(num: 0, storeID: "118519786", success: 10, fail: 5, lastState: "success", lastTime: "2022.01.02", pay: "kakaopay", exist: true)
        ]
        cell.storeInfo = StoreInfo(num: 1, storeID: "118519786", placeName: "플랜에이스터디카페 서초교대센터", addressName: "서울 서초구 서초동 1691-2", roadAddressName: "서울 서초구 서초중앙로24길 20", categoryGroupName: "", phone: "02-3143-0909", x: "127.015695735359", y: "37.4947251545286", feedback: dummyFeedback)
        cell.selectionStyle = .none
        cell.isEditMode = isEditMode
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !isEditMode { return }
        guard let cell = tableView.cellForRow(at: indexPath) as? BookMarkEditModeCell else { return }
        print("셀 탭")
        cell.cellSelected.toggle()
        print(cell.cellSelected)
    }
    
    
}
