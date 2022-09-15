//
//  FeedbackRequestViewController.swift
//  TapPlace
//
//  Created by 박상현 on 2022/09/07.
//

import UIKit

class FeedbackRequestViewController: CommonViewController {
    var feedbackViewModel = FeedbackViewModel()
    let customNavigationBar = CustomNavigationBar()
    var tableView = UITableView()
    let bottomButton = BottomButton()
    
    var myPayments: [FeedbackRequestModel] = []
    var dummyPayments: [FeedbackRequestModel] = []
    var otherPayments: [FeedbackRequestModel] = []
    var successFeedback: [LoadFeedbackList] = []
    var failFeedback: [LoadFeedbackList] = []
    
    var isLoadedAllPayments: Bool = false
    var storeInfo: StoreInfo? = StoreInfo.emptyStoreInfo {
        willSet {
            if let _ = newValue {} else {
                showToast(message: "가맹점 정보가 올바르지 않습니다.\n다시 시도해주세요.", view: self.view)
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        setupView()
        getFeedbackOfUserPayments()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBar?.showTabBar(hide: true)
        tabBar?.isShowFloatingButton = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBar?.showTabBar(hide: false)
        tabBar?.isShowFloatingButton = true
    }
}
//MARK: - Layout
extension FeedbackRequestViewController: CustomNavigationBarProtocol, BottomButtonProtocol {
    func didTapBottomButton() {
        if !bottomButton.isActive { return }
        bottomButton.setButtonStyle(title: "피드백 완료", type: .disabled, fill: true)
        bottomButton.isActive = false
        guard let storeID = storeInfo?.storeID else { return }
        feedbackViewModel.requestUpdateFeedback(storeID: storeID, feedback: [successFeedback, failFeedback]) { result in
            if let result = result {
                if let storeInfo = self.storeInfo {
                    self.successFeedback.forEach {
                        let tempFeedbackStore = UserFeedbackStoreModel(storeID: storeInfo.storeID, storeName: storeInfo.placeName, storeCategory: storeInfo.categoryGroupName, locationX: Double(storeInfo.x) ?? 0, locationY: Double(storeInfo.y) ?? 0, address: storeInfo.roadAddressName == "" ? storeInfo.addressName : storeInfo.roadAddressName, date: Date().getDate(3))
                        let tempFeedback = UserFeedbackModel(storeID: storeInfo.storeID, pay: $0.pay, feedback: true, date: Date().getDate(3))
                        self.storageViewModel.addFeedbackHistory(store: tempFeedbackStore, feedback: tempFeedback)
                    }
                    self.failFeedback.forEach {
                        let tempFeedbackStore = UserFeedbackStoreModel(storeID: storeInfo.storeID, storeName: storeInfo.placeName, storeCategory: storeInfo.categoryGroupName, locationX: Double(storeInfo.x) ?? 0, locationY: Double(storeInfo.y) ?? 0, address: storeInfo.roadAddressName == "" ? storeInfo.addressName : storeInfo.roadAddressName, date: Date().getDate(3))
                        let tempFeedback = UserFeedbackModel(storeID: storeInfo.storeID, pay: $0.pay, feedback: false, date: Date().getDate(3))
                        self.storageViewModel.addFeedbackHistory(store: tempFeedbackStore, feedback: tempFeedback)
                    }
                }
                let vc = FeedbackDoneViewController()
                vc.feedbackResult = result.feedbackResult
                vc.storeID = storeID
                self.navigationController?.pushViewController(vc, animated: true)
            } else {
                showToast(message: "알 수 없는 이유로 처리되지 않았습니다.\n다시 시도해주시기 바랍니다.", view: self.view)
                self.bottomButton.setButtonStyle(title: "피드백 완료", type: .activate, fill: true)
                self.bottomButton.isActive = true
            }
        }
        
    }
    
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
            feedbackTableView.rowHeight = 50
            feedbackTableView.separatorStyle = .none
            return feedbackTableView
        }()
        tableView = feedbackTableView
        
        //MARK: ViewPropertyManual
        self.view.backgroundColor = .white
        bottomButton.setButtonStyle(title: "피드백 완료", type: .disabled, fill: true)
        
        
        //MARK: AddSubView
        self.view.addSubview(customNavigationBar)
        self.view.addSubview(bottomButton)
        self.view.addSubview(tableView)
        
        
        //MARK: ViewContraints
        customNavigationBar.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(customNavigationBar.containerView)
        }
        bottomButton.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.leading.trailing.equalTo(safeArea)
            $0.top.equalTo(safeArea.snp.bottom).offset(-50)
        }
        tableView.snp.makeConstraints {
            $0.top.equalTo(customNavigationBar.snp.bottom)
            $0.leading.trailing.equalTo(safeArea)
            $0.bottom.equalTo(bottomButton.snp.top)
        }
        
        //MARK: ViewAddTarget
        
        
        //MARK: Delegate
        bottomButton.delegate = self
        
        
        //MARK: TableView
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(FeedbackRequestTableViewCell.self, forCellReuseIdentifier: FeedbackRequestTableViewCell.cellId)
    }
    /**
     * @ 네비게이션 속성 세팅
     * coder : sanghyeon
     */
    func setupNavigation() {
        customNavigationBar.titleText = "결제여부 피드백"
        customNavigationBar.isUseLeftButton = true
        customNavigationBar.delegate = self
    }
}
//MARK: - Feedback {
extension FeedbackRequestViewController {
    /**
     * @ 서버로부터 유저 결제수단의 피드백 목록 가져오기
     * coder : sanghyeon
     */
    func getFeedbackOfUserPayments() {
        let userPayments = storageViewModel.userFavoritePaymentsString
        guard let storeInfo = storeInfo else { return }
        feedbackViewModel.requestUserPaymentFeedback(storeInfo: storeInfo, userPayments: userPayments) { result in
            guard let result = result else { return }
            result.feedback.forEach {
//                print("[loaded feedback] feedback: \($0)")
                self.myPayments.append(FeedbackRequestModel(feedback: $0, selected: .none))
            }
            self.tableView.reloadData()
        }
    }
    /**
     * @ 서버로부터 유저 결제수단의 피드백 목록 가져오기
     * coder : sanghyeon
     */
    func getFeedbackOfMorePayments() {
        let userPayments = storageViewModel.userFavoritePaymentsString
        guard let storeInfo = storeInfo else { return }
        var allPayments: [PaymentModel] = PaymentModel.list
        var morePayments: [String] = []
        
        allPayments.forEach {
            let paymentString = PaymentModel.encodingPayment(payment: $0)
            if let _ = userPayments.firstIndex(of: paymentString) {} else {
                morePayments.append(paymentString)
            }
        }
        
        feedbackViewModel.requestMorePaymentFeedback(storeID: storeInfo.storeID, otherPayments: morePayments) { result in
            guard let result = result else { return }
            result.feedback.forEach {
//                print("[loaded feedback] feedback: \($0)")
                self.otherPayments.append(FeedbackRequestModel(feedback: $0, selected: .none))
            }
            self.tableView.reloadData()
        }
    }
}
//MARK: - TableView
extension FeedbackRequestViewController: UITableViewDelegate, UITableViewDataSource, FeedbackRequestCellProtocol {
    func didTapFeedbackButton(indexPath: IndexPath, payment: String, exist: Bool, type: FeedbackButton.FeedbackButtonStyle) {
//        print("버튼을 선택한...", indexPath, type, payment)
        guard let cell = tableView.cellForRow(at: indexPath) as? FeedbackRequestTableViewCell else { return }
        cell.setButtonStyle = type == .success ? .success : .fail
        let feedbackModel = LoadFeedbackList(exist: exist, pay: payment)
        if type == .success {
            if let _ = successFeedback.firstIndex(where: {$0.pay == payment}) { } else {
                successFeedback.append(feedbackModel)
            }
            if let index = failFeedback.firstIndex(where: {$0.pay == payment}) {
                failFeedback.remove(at: index)
            }
        } else {
            if let _ = failFeedback.firstIndex(where: {$0.pay == payment}) { } else {
                failFeedback.append(feedbackModel)
            }
            if let index = successFeedback.firstIndex(where: {$0.pay == payment}) {
                successFeedback.remove(at: index)
            }
        }
//        print("successFeedback: \(successFeedback)")
//        print("failFeedback: \(failFeedback)")
        
        if successFeedback.count + failFeedback.count > 0 {
            bottomButton.isActive = true
            bottomButton.setButtonStyle(title: "피드백 완료", type: .activate, fill: true)
        } else {
            bottomButton.isActive = false
            bottomButton.setButtonStyle(title: "피드백 완료", type: .disabled, fill: true)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return self.myPayments.count
        case 1: return self.otherPayments.count
        case 2: return 0
        default: return 0
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FeedbackRequestTableViewCell.cellId, for: indexPath) as? FeedbackRequestTableViewCell else { return UITableViewCell() }
        switch indexPath.section {
        case 0: cell.feedbackModel = myPayments[indexPath.row]
        case 1: cell.feedbackModel = otherPayments[indexPath.row]
        default: cell.feedbackModel = nil
        }
        
        if let payString = cell.feedbackModel?.feedback?.pay, let payment = PaymentModel.thisPayment(payment: payString) {
            cell.setButtonStyle = checkFeedback(payment: payment)
        }
        cell.cellIndexPath = indexPath
        cell.contentView.isUserInteractionEnabled = false
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section != 2 || isLoadedAllPayments { return nil }
        return setupFooterView()
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section != 2 || isLoadedAllPayments { return .zero }
        return 50
    }
    
    func setupFooterView() -> UIView {
        let footerView = UIView()
        let topLine: UIView = {
            let topLine = UIView()
            topLine.backgroundColor = .init(hex: 0xDBDEE8, alpha: 0.4)
            return topLine
        }()
        let filterButton: UIButton = {
            let filterButton = UIButton(type: .system)
            filterButton.semanticContentAttribute = .forceRightToLeft
            filterButton.imageEdgeInsets = UIEdgeInsets(top: .zero, left: 5, bottom: .zero, right: .zero)
            filterButton.setTitle("모든 결제수단 보기", for: .normal)
            filterButton.setImage(UIImage(systemName: "chevron.down"), for: .normal)
            filterButton.setPreferredSymbolConfiguration(.init(pointSize: CommonUtils.resizeFontSize(size: 14), weight: .regular, scale: .default), forImageIn: .normal)
            filterButton.tintColor = .init(hex: 0x333333)
            filterButton.titleLabel?.font = .systemFont(ofSize: CommonUtils.resizeFontSize(size: 14))
            return filterButton
        }()
        filterButton.addTarget(self, action: #selector(didTapLoadAllPaymentButton), for: .touchUpInside)
        
        footerView.addSubview(topLine)
        footerView.addSubview(filterButton)
        
        topLine.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(1)
        }
        filterButton.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        return footerView
    }
    @objc func didTapLoadAllPaymentButton() {
        isLoadedAllPayments = true
        getFeedbackOfMorePayments()
    }
    
    /**
     * @ 선택된 피드백이 배열에 있는가!?
     * coder : sanghyeon
     */
    func checkFeedback(payment: PaymentModel) -> FeedbackButton.FeedbackButtonStyle {
        if let _ = successFeedback.firstIndex(where: {$0.pay == PaymentModel.encodingPayment(payment: payment)}) {
            return .success
        }
        if let _ = failFeedback.firstIndex(where: {$0.pay == PaymentModel.encodingPayment(payment: payment)}) {
            return .fail
        }
        return .base
    }
}
