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
    var storageViewModel = StorageViewModel()
    var feedbackList: [UserFeedbackModel] = []
    var feedbackListArray: [String: [UserFeedbackModel]] = [:]
    
    let customNavigationBar = CustomNavigationBar()
    let filterTitle = MoreListFilterTitle()
    var tableView = UITableView()
    
    var filterAsc: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadFeedback()
        setupNavigation()
        setupView()
        
        print(feedbackListArray.count)
        feedbackListArray.sorted {$0.0 > $1.0}
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBar?.showTabBar(hide: true)
    }
}

//MARK: - Layout
extension FeedbackListViewController: FilterTitleProtocol {
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
        feedbackList = storageViewModel.loadFeedback()
        feedbackListArray = setupFeedbackArray(feedback: feedbackList)
    }
    /**
     * @ 피드백 배열 날짜별 그룹화
     * coder : sanghyeon
     */
    func setupFeedbackArray(feedback: [UserFeedbackModel]) -> [String: [UserFeedbackModel]] {
        let tempDic = Dictionary
            .init(grouping: feedbackList, by: {$0.date})
        return tempDic
    }
}

//MARK: - TableView
extension FeedbackListViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return feedbackListArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionTitle = Array(feedbackListArray)[section].key
        let numberOfSection = feedbackListArray[sectionTitle]
        guard let numberOfSection = numberOfSection else { return 0 }
        return numberOfSection.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let feedback = Array(feedbackListArray)[indexPath.section].value[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FeedbackListCell.cellId, for: indexPath) as? FeedbackListCell else { return UITableViewCell() }
        cell.feedback = feedback
                
        return cell
    }
    
    //MARK: Header & Footer
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return setupHeaderView(title: Array(feedbackListArray)[section].key)
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
