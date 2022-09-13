//
//  FeedbackRequestViewController.swift
//  TapPlace
//
//  Created by 박상현 on 2022/09/07.
//

import UIKit

class FeedbackRequestViewController: CommonViewController {
    let customNavigationBar = CustomNavigationBar()
    var tableView = UITableView()
    let bottomButton = BottomButton()
    
    var myPayments: [FeedbackRequestModel] = []
    var dummyPayments: [FeedbackRequestModel] = []
    var otherPayments: [FeedbackRequestModel] = []
    var successFeedback: [String] = []
    var failFeedback: [String] = []
    
    var isLoadedAllPayments: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        setupView()
        
        
        myPayments = [
            FeedbackRequestModel(payment: PaymentModel.thisPayment(payment: "kakaopay"), selected: nil),
            FeedbackRequestModel(payment: PaymentModel.thisPayment(payment: "apple_visa"), selected: nil),
            FeedbackRequestModel(payment: PaymentModel.thisPayment(payment: "apple_master"), selected: nil),
            FeedbackRequestModel(payment: PaymentModel.thisPayment(payment: "conless_visa"), selected: nil),
            FeedbackRequestModel(payment: PaymentModel.thisPayment(payment: "zeropay"), selected: nil)
        ]
        dummyPayments = [
            FeedbackRequestModel(payment: PaymentModel.thisPayment(payment: "naverpay"), selected: nil),
            FeedbackRequestModel(payment: PaymentModel.thisPayment(payment: "payco"), selected: nil),
            FeedbackRequestModel(payment: PaymentModel.thisPayment(payment: "apple_jcb"), selected: nil),
            FeedbackRequestModel(payment: PaymentModel.thisPayment(payment: "google_visa"), selected: nil),
            FeedbackRequestModel(payment: PaymentModel.thisPayment(payment: "google_master"), selected: nil),
            FeedbackRequestModel(payment: PaymentModel.thisPayment(payment: "google_maestro"), selected: nil),
            FeedbackRequestModel(payment: PaymentModel.thisPayment(payment: "conless_master"), selected: nil),
            FeedbackRequestModel(payment: PaymentModel.thisPayment(payment: "conless_union"), selected: nil),
            FeedbackRequestModel(payment: PaymentModel.thisPayment(payment: "conless_amex"), selected: nil),
            FeedbackRequestModel(payment: PaymentModel.thisPayment(payment: "conless_jcb"), selected: nil)
        ]
        
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
extension FeedbackRequestViewController {
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

    }
}
//MARK: - TableView
extension FeedbackRequestViewController: UITableViewDelegate, UITableViewDataSource, FeedbackRequestCellProtocol {
    func didTapFeedbackButton(indexPath: IndexPath, payment: String, type: FeedbackButton.FeedbackButtonStyle) {
        print("버튼을 선택한...", indexPath, type, payment)
        guard let cell = tableView.cellForRow(at: indexPath) as? FeedbackRequestTableViewCell else { return }
        cell.setButtonStyle = type == .success ? .success : .fail
        if type == .success {
            if let index = successFeedback.firstIndex(where: {$0 == payment}) { } else {
                successFeedback.append(payment)
            }
            if let index = failFeedback.firstIndex(where: {$0 == payment}) {
                failFeedback.remove(at: index)
            }
        } else {
            if let index = failFeedback.firstIndex(where: {$0 == payment}) { } else {
                failFeedback.append(payment)
            }
            if let index = successFeedback.firstIndex(where: {$0 == payment}) {
                successFeedback.remove(at: index)
            }
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
        
        if let payment = cell.feedbackModel?.payment {
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
        otherPayments = dummyPayments
        tableView.reloadData()
    }
    
    /**
     * @ 선택된 피드백이 배열에 있는가!?
     * coder : sanghyeon
     */
    func checkFeedback(payment: PaymentModel) -> FeedbackButton.FeedbackButtonStyle {
        if let _ = successFeedback.firstIndex(of: PaymentModel.encodingPayment(payment: payment)) {
            return .success
        }
        if let _ = failFeedback.firstIndex(of: PaymentModel.encodingPayment(payment: payment)) {
            return .fail
        }
        return .base
    }
    
}
