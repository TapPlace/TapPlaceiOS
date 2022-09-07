//
//  FeedbackDoneViewController.swift
//  TapPlace
//
//  Created by 이상준 on 2022/09/04.
//

import Foundation
import UIKit


class FeedbackDoneViewController: UIViewController {
    
    let customNavigationBar = CustomNavigationBar()
    
    override func viewDidLoad() {
        setupView()
        setLayout()
        
        customNavigationBar.delegate = self
        customNavigationBar.isDrawShadow = false
        customNavigationBar.isDrawBottomLine = false
        customNavigationBar.isUseLeftButton = true
        
        configureTableView()
    }
    
    private lazy var storePaymentTableView: UITableView = {
        let storePaymentTableView = UITableView()
        storePaymentTableView.register(StorePaymentTableViewCell.self, forCellReuseIdentifier: StorePaymentTableViewCell.identifier)
        storePaymentTableView.separatorInset.left = 20
        storePaymentTableView.separatorInset.right = 20
        storePaymentTableView.allowsSelection = false
        return storePaymentTableView
    }()
    
    private func configureTableView() {
        self.storePaymentTableView.dataSource = self
        self.storePaymentTableView.delegate = self
        self.storePaymentTableView.backgroundColor = .white
    }
}

extension FeedbackDoneViewController {
    
    private func setupView() {
        view.backgroundColor = .white
    }
    
    private func setLayout() {
        let naviTitle: UILabel = {
            let naviTitle = UILabel()
            naviTitle.font = .boldSystemFont(ofSize: 17)
            naviTitle.text = "피드백 완료"
            return naviTitle
        }()
        
        let imgView: UIImageView = {
            let imgView = UIImageView()
            return imgView
        }()
        
        let label: UILabel = {
            let label = UILabel()
            label.text = "피드백이 완료되었습니다!\n오늘 피드백 횟수가 2번 남아있어요."
            label.textColor = .init(hex: 0x707070)
            label.font = .systemFont(ofSize: 15)
            label.numberOfLines = 2
            label.textAlignment = .center
            label.sizeToFit()
            return label
        }()
        
        let lineView: UIView = {
            let lineView = UIView()
            lineView.backgroundColor = UIColor(red: 0.859, green: 0.871, blue: 0.91, alpha: 0.4)
            return lineView
        }()
        
        let titleLbl: UILabel = {
            let titleLbl = UILabel()
            titleLbl.text = "결과확인"
            titleLbl.font = .systemFont(ofSize: 15)
            titleLbl.textColor = .init(hex: 0x707070)
            titleLbl.sizeToFit()
            return titleLbl
        }()
        
        let button: BottomButton = {
            let button = BottomButton()
            button.setButtonStyle(title: "확인", type: .activate, fill: true)
            return button
        }()
        
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
        
        view.addSubview(imgView)
        imgView.snp.makeConstraints {
            $0.top.equalTo(customNavigationBar.snp.bottom).offset(30)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(60)
        }
        
        view.addSubview(label)
        label.snp.makeConstraints {
            $0.top.equalTo(imgView.snp.bottom).offset(18)
            $0.centerX.equalToSuperview()
        }
        
        view.addSubview(lineView)
        lineView.snp.makeConstraints {
            $0.top.equalTo(label.snp.bottom).offset(30)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(6)
        }
        
        view.addSubview(button)
        button.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-50)
        }
        
        view.addSubview(titleLbl)
        titleLbl.snp.makeConstraints {
            $0.top.equalTo(lineView.snp.bottom).offset(24)
            $0.leading.equalToSuperview().offset(20)
        }
        
        view.addSubview(storePaymentTableView)
        storePaymentTableView.snp.makeConstraints {
            $0.top.equalTo(titleLbl.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(button.snp.top)
        }
    }
}

extension FeedbackDoneViewController: CustomNavigationBarProtocol {
    func didTapLeftButton() {
        self.navigationController?.popViewController(animated: true)
    }
}

extension FeedbackDoneViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        StorePaymentModel.lists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: StorePaymentTableViewCell.identifier, for: indexPath) as! StorePaymentTableViewCell
        
        let storePaymentModel = StorePaymentModel.lists[indexPath.row]
        cell.prepare(payName: storePaymentModel.payName, success: storePaymentModel.success, successDate: storePaymentModel.successDate, successRate: storePaymentModel.successRate)
        
        return cell
    }
}