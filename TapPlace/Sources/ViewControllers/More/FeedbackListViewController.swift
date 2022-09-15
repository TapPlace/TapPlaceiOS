//
//  FeedbackListViewController.swift
//  TapPlace
//
//  Created by 박상현 on 2022/09/08.
//  배열 -> 딕셔너리 참고 : https://stackoverflow.com/questions/53452318/swift-adding-value-to-an-array-inside-a-dictionary
//  딕셔너리 정렬 참고 : https://2unbini.github.io/%F0%9F%93%82%20all/swift/dictionary-sorted/
//

import UIKit

class FeedbackListViewController: CommonViewController {
    var feedbackStoreList: [UserFeedbackStoreModel] = []
    var feedbackListArray: [String: [UserFeedbackStoreModel]] = [:]
    
    let customNavigationBar = CustomNavigationBar()
    let filterTitle = MoreListFilterTitle()
    var tableView = UITableView()
    
    var filterAsc: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadFeedback()
        setupNavigation()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBar?.hideTabBar(hide: true)
    }
}

//MARK: - Layout
extension FeedbackListViewController: FilterTitleProtocol, CustomNavigationBarProtocol {
    func didTapLeftButton() {
        self.navigationController?.popViewController(animated: true)
    }
    
    /**
     * @ 초기 레이아웃 설정
     * coder : sanghyeon
     */
    func setupView() {
        //MARK: ViewDefine
        let safeArea = view.safeAreaLayoutGuide
        let feedbackTableView: UITableView = {
            let feedbackTableView = UITableView()
            feedbackTableView.rowHeight = 100
            feedbackTableView.separatorStyle = .none
            
            return feedbackTableView
        }()
        tableView = feedbackTableView
        
        
        //MARK: ViewPropertyManual
        self.view.backgroundColor = .white
        filterTitle.isUseEditMode = false
        filterTitle.setFilterName = "등록순"
        filterTitle.filterCount = storageViewModel.numberOfFeedback

        
        
        //MARK: AddSubView
        self.view.addSubview(customNavigationBar)
        self.view.addSubview(filterTitle)
        self.view.addSubview(tableView)
        
        
        //MARK: ViewContraints
        customNavigationBar.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(customNavigationBar.containerView)
        }
        filterTitle.snp.makeConstraints {
            $0.top.equalTo(customNavigationBar.snp.bottom)
            $0.leading.trailing.equalTo(safeArea).inset(20)
            $0.height.equalTo(50)
        }
        tableView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalTo(safeArea)
            $0.top.equalTo(filterTitle.snp.bottom)
        }
        
        
        //MARK: ViewAddTarget
        tableView.register(FeedbackListCell.self, forCellReuseIdentifier: FeedbackListCell.cellId)
        
        
        //MARK: Delegate
        filterTitle.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
    }
    /**
     * @ 네비게이션 속성 세팅
     * coder : sanghyeon
     */
    func setupNavigation() {
        customNavigationBar.titleText = "내가 한 피드백"
        customNavigationBar.isUseLeftButton = true
        customNavigationBar.delegate = self
    }
    /**
     * @ 필터 정렬 버튼 클릭 함수
     * coder : sanghyeon
     */
    func didTapFilterSortButton() {
        self.filterAsc.toggle()
        if filterAsc {
            filterTitle.filterButtonSetImage = "chevron.down"
        } else {
            filterTitle.filterButtonSetImage = "chevron.up"

        }
        tableView.reloadData()
    }
    /**
     * @ 필터 편집 버튼 클릭 함수
     * coder : sanghyeon
     */
    func didTapFilterEditButton() {
        
    }
}

//MARK: - Feedback
extension FeedbackListViewController {
    /**
     * @ 피드백 목록 불러오기
     * coder : sanghyeon
     */
    func loadFeedback() {
        feedbackStoreList = storageViewModel.loadFeedbackStore()
        feedbackListArray = setupFeedbackArray(feedback: feedbackStoreList)
    }
    /**
     * @ 피드백 배열 날짜별 그룹화
     * coder : sanghyeon
     */
    func setupFeedbackArray(feedback: [UserFeedbackStoreModel]) -> [String: [UserFeedbackStoreModel]] {
        let tempDic = Dictionary
            .init(grouping: feedbackStoreList, by: {$0.date})
        return tempDic
    }
}

//MARK: - TableView
extension FeedbackListViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        let sortedFeedbackListArray = feedbackListArray.sorted { (first, second) in
            if filterAsc {
                return first.key > second.key
            } else {
                return first.key < second.key
            }
        }
        return sortedFeedbackListArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sortedFeedbackListArray = feedbackListArray.sorted { (first, second) in
            if filterAsc {
                return first.key > second.key
            } else {
                return first.key < second.key
            }
        }
        let sectionTitle = Array(sortedFeedbackListArray)[section].key
        let numberOfSection = feedbackListArray[sectionTitle]
        guard let numberOfSection = numberOfSection else { return 0 }
        return numberOfSection.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sortedFeedbackListArray = feedbackListArray.sorted { (first, second) in
            if filterAsc {
                return first.key > second.key
            } else {
                return first.key < second.key
            }
        }
        let feedback = Array(sortedFeedbackListArray)[indexPath.section].value[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FeedbackListCell.cellId, for: indexPath) as? FeedbackListCell else { return UITableViewCell() }
        cell.feedback = feedback
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = FeedbackDetailViewController()
        guard let cell = tableView.cellForRow(at: indexPath) as? FeedbackListCell else { return }
        guard let feedback = cell.feedback else { return }
        vc.feedbackStore = feedback
        vc.feedbackList = storageViewModel.loadFeedback(store: feedback)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: Header & Footer
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sortedFeedbackListArray = feedbackListArray.sorted { (first, second) in
            if filterAsc {
                return first.key > second.key
            } else {
                return first.key < second.key
            }
        }
        return setupHeaderView(title: Array(sortedFeedbackListArray)[section].key)
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == feedbackListArray.count - 1 { return nil }
        return setupFooterView()
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == feedbackListArray.count - 1 { return .zero }
        return 6
    }
    
    
    /**
     * @ 헤더뷰 생성
     * coder : sanghyeon
     */
    func setupHeaderView(title: String) -> UIView {
        let headerView: UIView = {
            let headerView = UIView()
            headerView.backgroundColor = .white
            return headerView
        }()
        let dateLabel: UILabel = {
            let dateLabel = UILabel()
            dateLabel.sizeToFit()
            dateLabel.textColor = .black
            dateLabel.font = .systemFont(ofSize: CommonUtils.resizeFontSize(size: 18), weight: .semibold)
            dateLabel.text = title
            return dateLabel
        }()
        
        headerView.addSubview(dateLabel)
        
        dateLabel.snp.makeConstraints {
            $0.leading.equalTo(headerView).offset(20)
            $0.centerY.equalTo(headerView)
        }
        
        return headerView
    }
    /**
     * @ 푸터뷰 생성
     * coder : sanghyeon
     */
    func setupFooterView() -> UIView {
        let footerView: UIView = {
            let footerView = UIView()
            footerView.backgroundColor = .init(hex: 0xDBDEE8, alpha: 0.4)
            return footerView
        }()
        
        return footerView
    }
    
    
    
}
