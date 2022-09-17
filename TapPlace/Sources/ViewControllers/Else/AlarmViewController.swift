//
//  AlarmViewController.swift
//  TapPlace
//
//  Created by 이상준 on 2022/09/06.
//

import UIKit

// 알람
class AlarmViewController: CommonViewController {
    
    let customNavigationBar = CustomNavigationBar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setLayout()
        
        customNavigationBar.delegate = self
        customNavigationBar.isDrawShadow = false
        customNavigationBar.isDrawBottomLine = false
        customNavigationBar.titleText = "알림"
        customNavigationBar.isUseLeftButton = true
        
        configureTableView()
    }
    
    private lazy var alarmTableView: UITableView = {
        let alarmTableView = UITableView()
        alarmTableView.register(AlarmCell.self, forCellReuseIdentifier: AlarmCell.identifier)
        alarmTableView.separatorInset.left = 20
        alarmTableView.separatorInset.right = 20
        alarmTableView.allowsSelection = false
        return alarmTableView
    }()
    
    private let settingBtn: UIButton = {
        let settingBtn = UIButton()
        settingBtn.setTitle("알림 설정", for: .normal)
        settingBtn.setTitleColor(.init(hex: 0x4E77FB), for: .normal)
        settingBtn.titleLabel?.font = .systemFont(ofSize: 15)
//        settingBtn.addTarget(self, action: #secletor(), for: .touchUpInside)
        return settingBtn
    }()
    
    // 알림 설정 페이지 완성 후 추후 작업
//    @objc func goToAlarmSettingVC() {
//
//    }
}

extension AlarmViewController {
    private func setupView() {
        self.view.backgroundColor = .white
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // 탭바
//        print("뷰 사라집니다.")
        tabBar?.hideTabBar(hide: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 탭바
//        print("뷰 나타납니다.")
        tabBar?.hideTabBar(hide: true)
    }
    
    // 테이블 뷰 구성 메소드
    private func configureTableView() {
        self.alarmTableView.dataSource = self
        self.alarmTableView.delegate = self
        self.alarmTableView.backgroundColor = .white
    }
    
    private func setLayout() {
        view.addSubview(customNavigationBar)
        customNavigationBar.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(customNavigationBar.containerView)
        }
        
        customNavigationBar.addSubview(settingBtn)
        settingBtn.snp.makeConstraints {
            $0.bottom.equalTo(customNavigationBar.containerView).offset(-8)
            $0.trailing.equalToSuperview().offset(-20)
        }
        
        view.addSubview(alarmTableView)
        alarmTableView.snp.makeConstraints {
            $0.top.equalTo(customNavigationBar.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
}

extension AlarmViewController: CustomNavigationBarProtocol {
    func didTapLeftButton() {
        self.navigationController?.popViewController(animated: true)
    }
}

extension AlarmViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 117
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AlarmModel.lists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AlarmCell.identifier, for: indexPath) as! AlarmCell
        let alarmModel = AlarmModel.lists[indexPath.row]
        cell.prepare(subTitle: alarmModel.subTitle, title: alarmModel.title, date: alarmModel.time)
        return cell
    }
}
