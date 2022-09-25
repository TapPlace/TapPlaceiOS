//
//  FeedbackDetailViewController.swift
//  TapPlace
//
//  Created by 이상준 on 2022/09/08.
//

import UIKit

class FeedbackDetailViewController: UIViewController {
    var storeViewModel = StoreViewModel()
    var storageViewModel = StorageViewModel()
    
    var feedbackStore: UserFeedbackStoreModel? = nil {
        willSet {
            guard let store = newValue else { return }
            customNavigationBar.titleText = store.storeName
            // FIXME: MVVM 수정
//            storeViewModel.requestStoreInfo(storeID: store.storeID, pays: storageViewModel.userFavoritePaymentsString) { result in
//                if let result = result {
//                    self.storeInfo = result
//                    self.locationBtn.isEnabled = true
//                }
//                
//            }
        }
    }
    
    var storeInfo: StoreInfo?
    
    var feedbackList: [UserFeedbackModel]? = nil
    
    private let customNavigationBar = CustomNavigationBar()
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(FeedbackDetailCell.self, forCellReuseIdentifier: FeedbackDetailCell.identifier)
        tableView.separatorInset.left = 20
        tableView.separatorInset.right = 20
        tableView.allowsSelection = false
        return tableView
    }()
    
    private let locationBtn: UIButton = {
        let locationBtn = UIButton(type: .system)
        locationBtn.setImage(named: "location")
        locationBtn.tintColor = .init(hex: 0x4E77FB)
        locationBtn.isEnabled = false
        return locationBtn
    }()
    
    private func configureTableView() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.backgroundColor = .white
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setLayout()
        
        customNavigationBar.delegate = self
        customNavigationBar.isDrawShadow = false
        customNavigationBar.isDrawBottomLine = false
        customNavigationBar.isUseLeftButton = true
        
        configureTableView()
    }
    
    @objc func didTapLocationButton() {
        // 검색창을 눌러서 접근했을 떄
        let mainVC = MainViewController()
        mainVC.storeInfo = storeInfo
        mainVC.isMainMode = false
        self.navigationController?.pushViewController(mainVC, animated: true)
    }
}

extension FeedbackDetailViewController {
    private func setupView() {
        self.view.backgroundColor = .white
    }
    
    private func setLayout() {
        view.addSubview(customNavigationBar)
        customNavigationBar.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(customNavigationBar.containerView)
        }
        
        customNavigationBar.addSubview(locationBtn)
        locationBtn.snp.makeConstraints {
            $0.bottom.equalTo(customNavigationBar.containerView).offset(-10)
            $0.trailing.equalToSuperview().offset(-20)
            $0.width.height.equalTo(30)
        }
        locationBtn.addTarget(self, action: #selector(didTapLocationButton), for: .touchUpInside)
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.top.equalTo(customNavigationBar.snp.bottom).offset(30)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
}

// MARK: - 커스텀 네비게이션 바 프로토콜 구현
extension FeedbackDetailViewController: CustomNavigationBarProtocol {
    func didTapLeftButton() {
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: - 테이블 뷰 델리게이트, 데이터소스
extension FeedbackDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let feedbackList = feedbackList else { return 0 }
        return feedbackList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FeedbackDetailCell.identifier, for: indexPath) as! FeedbackDetailCell
        guard let feedbackList = feedbackList else { return UITableViewCell() }
        cell.prepare(feedback: feedbackList[indexPath.row])
        return cell
    }
}
