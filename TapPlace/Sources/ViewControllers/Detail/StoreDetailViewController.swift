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


private var xoStickyHeaderKey: UInt8 = 0
extension UIScrollView {
    
    public var stickyHeader: StickyHeader! {
        
        get {
            var header = objc_getAssociatedObject(self, &xoStickyHeaderKey) as? StickyHeader
            
            if header == nil {
                header = StickyHeader()
                header!.scrollView = self
                objc_setAssociatedObject(self, &xoStickyHeaderKey, header, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
            return header!
        }
    }
}


class StoreDetailViewController: UIViewController {
    
    let toolBar = CustomToolBar()
    let backButton = UIButton() // 네이버 지도 뷰 위 back 버튼
    var naverMapView: NMFMapView = NMFMapView() // 네이버 지도 뷰
    
    
    var navigationView = NavigationBar()
    
    
    private var dataSource = [StoreDetailModel]()
    
    override func viewDidLoad() {
        setupView()
        setupMapView()
        setLayout()
        configureTableView()
        self.settingData()
        
        storeDetailTableView.stickyHeader.view = naverMapView
        storeDetailTableView.stickyHeader.height = 200
        storeDetailTableView.stickyHeader.minimumHeight = 60
        
        navigationView.frame = CGRect(x: 0, y: 0, width: naverMapView.frame.width, height: 200)
//        navigationView.backgroundColor = .brown
        navigationView.alpha = 0
        storeDetailTableView.stickyHeader.view = navigationView
    }
    
    private lazy var storeDetailTableView: UITableView = {
        let storeDetailTableView = UITableView()
        storeDetailTableView.translatesAutoresizingMaskIntoConstraints = false
        storeDetailTableView.register(StoreInfoTableViewCell.self, forCellReuseIdentifier: StoreInfoTableViewCell.identifier)
        storeDetailTableView.register(StorePaymentTableViewCell.self, forCellReuseIdentifier: StorePaymentTableViewCell.identifier)
        storeDetailTableView.separatorInset.left = 20
        storeDetailTableView.separatorInset.right = 20
        storeDetailTableView.allowsSelection = false
        return storeDetailTableView
    }()
    
    private func configureTableView() {
        self.storeDetailTableView.dataSource = self
        self.storeDetailTableView.delegate = self
        self.storeDetailTableView.backgroundColor = .white
    }
    
    
    // 더미 데이터 셋팅
    private func settingData() {
        let storeInfoModel = StoreInfoModel(
            storeName: "세븐일레븐 염창점",
            storeKind: "편의점",
            address: "50m . 서울 강서구 강서로 463",
            tel: "02-3664-6722"
        )
        
        let storeInfoSection = StoreDetailModel.storeInfo([storeInfoModel])
        
        let storePayments = [
            StorePaymentModel(payName: "카카오 페이", success: true, successDate: "2022.08.20", successRate: 95),
            StorePaymentModel(payName: "애플페이 - VISA", success: false, successDate: "2022.08.19", successRate: 80),
            StorePaymentModel(payName: "네이버 페이", success: true, successDate: "2022.08.21", successRate: 97)
        ]
        
        let storePaymentSection = StoreDetailModel.storePayment(storePayments)
        self.dataSource = [storeInfoSection, storePaymentSection]
        self.storeDetailTableView.reloadData()
    }
    
    // MARK: Scrollview
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let offset = scrollView.contentOffset.y
        let changeStartOffset: CGFloat = -180
        let changeSpeed: CGFloat = 30
        navigationView.alpha = min(1.0, (offset - changeStartOffset) / changeSpeed)
    }
}

// MARK: 레이아웃
extension StoreDetailViewController {
    private func setupView() {
        self.view.insetsLayoutMarginsFromSafeArea = false
        self.view.backgroundColor = .white
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
            $0.top.equalToSuperview()
//            $0.top.equalTo(naverMapView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(toolBar.snp.top)
        }
    }
}

// MARK: - Naver 맵뷰 
extension StoreDetailViewController {
    func setupMapView() {
        naverMapView = NMFMapView(frame: view.frame)
        naverMapView.isScrollGestureEnabled = false
        naverMapView.isZoomGestureEnabled = false
        
        backButton.backgroundColor = .white
        backButton.clipsToBounds = true
        backButton.layer.cornerRadius = 20
        backButton.tintColor = .black
        backButton.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        
//        view.addSubview(naverMapView)
//        naverMapView.snp.makeConstraints{
//            $0.top.equalToSuperview()
//            $0.width.equalToSuperview()
//            $0.height.equalTo(200)
//        }

        naverMapView.addSubview(backButton)
        backButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(56)
            $0.left.equalToSuperview().offset(20)
            $0.width.height.equalTo(40)
        }
    }
}

// MARK: - 테이블 뷰
extension StoreDetailViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 190
        } else {
            return 140
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        self.dataSource.count
    }
    
    // 헤더뷰
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == self.dataSource.count - 2 {
            // 헤더 뷰 기본값 0으로 대응
            if #available(iOS 15.0, *) {
                tableView.sectionHeaderTopPadding = 0
            } else {
                tableView.tableHeaderView = .init(frame: .init(x: 0, y: 0, width: 0, height: CGFloat.leastNonzeroMagnitude))
            }
            return 0
        }
        return 40
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .white
        
        let rightLbl = UILabel()
        rightLbl.text = "결제수단"
        rightLbl.font = .boldSystemFont(ofSize: 17)
        rightLbl.sizeToFit()
        
        let leftBtn = UIButton()
        leftBtn.setTitle("나도 피드백하기", for: .normal)
        leftBtn.titleLabel?.font = .boldSystemFont(ofSize: 15)
        leftBtn.setTitleColor(UIColor(red: 0.306, green: 0.467, blue: 0.984, alpha: 1), for: .normal)
        
        let imgView = UIImageView()
        imgView.image = UIImage(named: "")
        
        view.addSubview(rightLbl)
        view.addSubview(leftBtn)
        view.addSubview(imgView)
        
        rightLbl.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.leading.equalToSuperview().offset(20)
        }
        
        leftBtn.snp.makeConstraints {
            $0.top.equalToSuperview().offset(15)
            $0.trailing.equalToSuperview().offset(-20)
        }
        
        imgView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(18)
            $0.trailing.equalTo(leftBtn).offset(-6)
        }
        
        
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == self.dataSource.count - 1 { return 0 }
        return 6
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.859, green: 0.871, blue: 0.91, alpha: 0.4)
        return view
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch self.dataSource[section] {
        case let .storeInfo(storeInfoModel):
            return storeInfoModel.count
            
        case let .storePayment(storePaymentModel):
            return storePaymentModel.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch self.dataSource[indexPath.section] {
        case let .storeInfo(storeInfoModels):
            let cell = tableView.dequeueReusableCell(withIdentifier: StoreInfoTableViewCell.identifier, for: indexPath) as! StoreInfoTableViewCell
            let storeInfoModel = storeInfoModels[indexPath.row]
            cell.prepare(storeName: storeInfoModel.storeName, storeKind: storeInfoModel.storeKind, address: storeInfoModel.address, tel: storeInfoModel.tel)
            
            // 셀의 라인을 지워줌
            cell.separatorInset = UIEdgeInsets(top: 0, left: cell.bounds.size.width, bottom: 0, right: 0);
            return cell
        case let .storePayment(storePaymentModels):
            let cell = tableView.dequeueReusableCell(withIdentifier: StorePaymentTableViewCell.identifier, for: indexPath) as! StorePaymentTableViewCell
            let storePaymentModel = storePaymentModels[indexPath.row]
            cell.prepare(payName: storePaymentModel.payName, success: storePaymentModel.success, successDate: storePaymentModel.successDate, successRate: storePaymentModel.successRate)
            return cell
        }
    }
}
