//
//  StoreDetailViewController.swift
//  TapPlace
//
//  Created by 이상준 on 2022/08/26.
//

import Foundation
import UIKit
import NMapsMap
import CoreLocation
import SnapKit
import FloatingPanel

class StoreDetailViewController: UIViewController {
     
    let toolBar = CustomToolBar()
    let backButton = UIButton() // 네이버 지도 뷰 위 back 버튼
    var naverMapView: NMFMapView = NMFMapView() // 네이버 지도 뷰
    
    var dataSource = [StoreDetailModel]()
    
    override func viewDidLoad() {
        setupView()
        setupMapView()
        setLayout()
        configureTableView()
        self.settingData()
    }
    
    private lazy var storeDetailTableView: UITableView = {
        let storeDetailTableView = UITableView()
        storeDetailTableView.translatesAutoresizingMaskIntoConstraints = false
        storeDetailTableView.register(StoreInfoTableViewCell.self, forCellReuseIdentifier: StoreInfoTableViewCell.identifier)
        storeDetailTableView.register(StorePaymentTableViewCell.self, forCellReuseIdentifier: StorePaymentTableViewCell.identifier)
        storeDetailTableView.allowsSelection = false
        return storeDetailTableView
    }()
    
    private func configureTableView() {
        self.storeDetailTableView.dataSource = self
        self.storeDetailTableView.delegate = self
        self.storeDetailTableView.backgroundColor = .white
//        self.storeDetailTableView.separatorStyle = .none
    }
    
    
    private func settingData() {
        self.dataSource = [
            .storeInfo(
                storeName: "세븐일레븐 염창점",
                storeKind: "편의점",
                address: "50m . 서울 강서구 강서로 463",
                tel: "02-3664-6722"
            ),
            .storePayment(payName: "카카오 페이", success: true, successDate: "2022.08.20", successRate: 95),
            .storePayment(payName: "애플페이 - VISA", success: false, successDate: "2022.08.19", successRate: 80),
            .storePayment(payName: "네이버 페이", success: true, successDate: "2022.08.21", successRate: 97)
        ]
        self.storeDetailTableView.reloadData()
        print(dataSource.count)
    }
}

extension StoreDetailViewController {
    private func setupView() {
        self.view.backgroundColor = .systemGray5
        self.navigationController?.navigationBar.isHidden = true
        /// 네비게이션 컨트롤러 스와이프 뒤로가기 제거
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    private func setLayout() {
        let safeArea = view.safeAreaLayoutGuide
        
        view.addSubview(toolBar)
        toolBar.snp.makeConstraints {
            $0.leading.trailing.bottom.equalTo(safeArea)
            $0.height.equalTo(toolBar.toolBar)
        }
        
        view.addSubview(storeDetailTableView)
        storeDetailTableView.snp.makeConstraints {
            $0.top.equalTo(naverMapView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(toolBar.snp.top)
        }
    }
}

// MARK: - Naver 맵뷰 
extension StoreDetailViewController {
    func setupMapView() {
        naverMapView = NMFMapView(frame: view.frame)
        
        backButton.backgroundColor = .white
        backButton.clipsToBounds = true
        backButton.layer.cornerRadius = 20
        backButton.tintColor = .black
        backButton.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        
        view.addSubview(naverMapView)
        naverMapView.snp.makeConstraints{
            $0.top.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.equalTo(200)
        }
        
        naverMapView.addSubview(backButton)
        backButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(56)
            $0.left.equalToSuperview().offset(20)
            $0.width.height.equalTo(40)
        }
    }
}

extension StoreDetailViewController: UITableViewDataSource, UITableViewDelegate {
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 2
//    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch self.dataSource[indexPath.row] {
        case let .storeInfo(storeName, storeKind, address, tel):
            let cell = tableView.dequeueReusableCell(withIdentifier: StoreInfoTableViewCell.identifier, for: indexPath) as! StoreInfoTableViewCell
            cell.prepare(storeName: storeName, storeKind: storeKind, address: address, tel: tel)
            return cell
        case let .storePayment(payName, success, successDate, successRate):
            let cell = tableView.dequeueReusableCell(withIdentifier: StorePaymentTableViewCell.identifier, for: indexPath) as! StorePaymentTableViewCell
            cell.prepare(payName: payName, success: success, successDate: successDate, successRate: successRate)
            return cell
        }
    }
}
