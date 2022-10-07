//
//  FeedbackDoneViewController.swift
//  TapPlace
//
//  Created by 이상준 on 2022/09/04.
// 

import UIKit

class FeedbackDoneViewController: CommonViewController {
    
    let customNavigationBar = CustomNavigationBar()
    var feedbackResult: [FeedbackResult]? = nil
    var storeID: String?
    var remainCount: Int = 0
    var contentViewHeight: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setLayout()
        
        customNavigationBar.delegate = self
        customNavigationBar.isDrawShadow = false
        customNavigationBar.isDrawBottomLine = false
        customNavigationBar.isUseLeftButton = true
        
        scrollView.delegate = self
        configureTableView()
        updateScrollView()
    }
    
    var resultLabel: UILabel = UILabel()
    
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .white
        return scrollView
    }()
    
    let contentView = UIView()
    let imgView = UIImageView()
    let lineView = UIView()
    let titleLbl = UILabel()
    let button = BottomButton()
    
    private lazy var storePaymentTableView: UITableView = {
        let storePaymentTableView = UITableView()
        storePaymentTableView.register(StorePaymentTableViewCell.self, forCellReuseIdentifier: StorePaymentTableViewCell.identifier)
        storePaymentTableView.separatorInset.left = 20
        storePaymentTableView.separatorInset.right = 20
        storePaymentTableView.allowsSelection = false
        storePaymentTableView.isScrollEnabled = false
        return storePaymentTableView
    }()
    
    private func configureTableView() {
        self.storePaymentTableView.dataSource = self
        self.storePaymentTableView.delegate = self
        self.storePaymentTableView.backgroundColor = .white
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

extension FeedbackDoneViewController: BottomButtonProtocol {
    func didTapBottomButton() {
        didTapLeftButton()
    }
    
    private func setupView() {
        view.backgroundColor = .white
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    private func setLayout() {
        contentView.backgroundColor = .white
        
        let naviTitle: UILabel = {
            let naviTitle = UILabel()
            naviTitle.font = .boldSystemFont(ofSize: 17)
            naviTitle.text = "피드백 완료"
            return naviTitle
        }()
        
        imgView.image = UIImage(named: "feedback_image")
        
        resultLabel = {
            let resultLabel = UILabel()
            resultLabel.text = "피드백이 완료되었습니다!\n오늘 피드백 횟수가 \(remainCount)번 남아있어요."
            resultLabel.textColor = .init(hex: 0x707070)
            resultLabel.font = .systemFont(ofSize: 15)
            resultLabel.numberOfLines = 2
            resultLabel.textAlignment = .center
            resultLabel.sizeToFit()
            return resultLabel
        }()
        
        lineView.backgroundColor = UIColor(red: 0.859, green: 0.871, blue: 0.91, alpha: 0.4)
        
        titleLbl.text = "결과확인"
        titleLbl.font = .systemFont(ofSize: 15)
        titleLbl.textColor = .init(hex: 0x707070)
        titleLbl.sizeToFit()
        
        button.setButtonStyle(title: "확인", type: .activate, fill: true)
        button.delegate = self
        
        view.addSubview(customNavigationBar)
        customNavigationBar.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(customNavigationBar.containerView)
        }
        
        customNavigationBar.addSubview(naviTitle)
        naviTitle.snp.makeConstraints {
            $0.bottom.equalTo(customNavigationBar.containerView).offset(-15)
            $0.centerX.equalTo(customNavigationBar)
        }
        
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints {
            $0.top.equalTo(customNavigationBar.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-50)
        }
        
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints {
            $0.edges.equalTo(scrollView)
            $0.width.equalTo(view.frame.width)
            $0.height.equalTo(contentViewHeight)
        }
        
        contentView.addSubview(imgView)
        imgView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(30)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(60)
        }
        
        contentView.addSubview(resultLabel)
        resultLabel.snp.makeConstraints {
            $0.top.equalTo(imgView.snp.bottom).offset(18)
            $0.centerX.equalToSuperview()
        }
        
        contentView.addSubview(lineView)
        lineView.snp.makeConstraints {
            $0.top.equalTo(resultLabel.snp.bottom).offset(30)
            $0.leading.trailing.equalTo(scrollView)
            $0.height.equalTo(6)
        }
        
        view.addSubview(button)
        button.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-50)
        }
        
        contentView.addSubview(titleLbl)
        titleLbl.snp.makeConstraints {
            $0.top.equalTo(lineView.snp.bottom).offset(24)
            $0.leading.equalToSuperview().offset(20)
        }
        
        contentView.addSubview(storePaymentTableView)
        storePaymentTableView.snp.makeConstraints {
            $0.top.equalTo(titleLbl.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(button.snp.top)
        }
    }
    
    func updateScrollView() {
        guard let feedbackResult = feedbackResult else { return }
        
        let elseHeight: CGFloat = 30 + imgView.frame.height + 18 + resultLabel.frame.height + 30 + lineView.frame.height + 24 + titleLbl.frame.height + 20 + button.frame.height + 65
        let tableViewHeight: CGFloat = CGFloat(140 * feedbackResult.count)
        
        contentViewHeight = elseHeight + tableViewHeight
        
        contentView.snp.remakeConstraints {
            $0.edges.equalTo(scrollView)
            $0.width.equalTo(view.frame.width)
            $0.height.equalTo(contentViewHeight)
        }
    }
}

extension FeedbackDoneViewController: CustomNavigationBarProtocol {
    func didTapLeftButton() {
        guard let vcStack = self.navigationController?.viewControllers else { return }
        guard let storeID = storeID else { return }
        for viewController in vcStack {
            if let vc = viewController as? StoreDetailViewController {
                vc.storeID = storeID
                self.navigationController?.popToViewController(vc, animated: true)
            }
        }
    }
}

extension FeedbackDoneViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let feedbackResult = feedbackResult else { return 0 }
        return feedbackResult.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let feedbackResult = feedbackResult else { return UITableViewCell() }
        let cell = tableView.dequeueReusableCell(withIdentifier: StorePaymentTableViewCell.identifier, for: indexPath) as! StorePaymentTableViewCell
        
        let feedback = feedbackResult[indexPath.row]
        cell.feedback = Feedback(num: 0, storeID: nil, success: feedback.success, fail: feedback.fail, lastState: feedback.lastState, lastTime: nil, pay: feedback.pay, exist: true)
        
        return cell
    }
}

extension FeedbackDoneViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
    }
}
