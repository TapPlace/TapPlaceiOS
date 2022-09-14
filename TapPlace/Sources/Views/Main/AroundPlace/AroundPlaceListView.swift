//
//  AroundPlaceListView.swift
//  TapPlace
//
//  Created by 박상현 on 2022/08/20.
//

import UIKit

protocol AroundPlaceControllerProtocol {
    func presentViewController(_ vc: UIViewController)
    func showFilterView()
}

protocol AroundPlaceMainControllerProtocol {
    func expendFloatingPanel()
}


class AroundPlaceListView: UIView, AroundPlaceApplyFilterProtocol {
    var address: String = "" {
        willSet {
            addressLabel.text = newValue + " 주변"
        }
    }
    
    func applyFilter() {
        guard let aroundPlaceList = AroundStoreModel.list else { return }
        
        let AroundFilter: [Int] = [
            AroundFilterModel.storeList.count,
            AroundFilterModel.paymentList.count
        ]
        storeButton.selectedCount = AroundFilter[0]
        paymentButton.selectedCount = AroundFilter[1]
        
        var tempCategoryFilteredArray: [AroundStores] = []
        var tempPaymentsFilteredArray: [AroundStores] = []
        
        if AroundFilter[0] > 0 {
            AroundFilterModel.storeList.forEach { category in
                let categoryTitle = category.title == "기타" ? "" : category.title
                let filteredCategory = aroundPlaceList.filter({$0.categoryGroupName == categoryTitle})
                filteredCategory.forEach {
                    tempCategoryFilteredArray.append($0)
                }
            }
        } else {
            tempCategoryFilteredArray = aroundPlaceList
        }
        
        if AroundFilter[1] > 0 {
            AroundFilterModel.paymentList.forEach { payment in
                let filteredPayment = aroundPlaceList.filter({$0.pays.contains(PaymentModel.encodingPayment(payment: payment))})
                filteredPayment.forEach { tempPayment in
                    if tempPaymentsFilteredArray.first(where: {$0.storeID == tempPayment.storeID}) == nil {
                        tempPaymentsFilteredArray.append(tempPayment)
                    }
                }
            }
        } else {
            tempPaymentsFilteredArray = aroundPlaceList
        }
        
        let setCategoryArray = Set(tempCategoryFilteredArray)
        let setPaymentArray = Set(tempPaymentsFilteredArray)
        filteredAroundPlaceList = Array(setCategoryArray.intersection(setPaymentArray))
        filteredAroundPlaceList = filteredAroundPlaceList.sorted(by: {$0.distance < $1.distance})
        tableView.reloadData()
    }
    
    var delegate: AroundPlaceControllerProtocol?
    var mainDelegate: AroundPlaceMainControllerProtocol?
    var storageViewModel = StorageViewModel()
    
    var filteredAroundPlaceList: [AroundStores] = []
    
    let containerView: UIView = {
        let containerView = UIView()
        return containerView
    }()
    let addressLabel: UILabel = {
        let addressLabel = UILabel()
        addressLabel.text = "지도의 현재 주소"
        addressLabel.font = .systemFont(ofSize: CommonUtils.resizeFontSize(size: 15), weight: .regular)
        addressLabel.textColor = .black
        addressLabel.sizeToFit()
        return addressLabel
    }()
    let distanceLabel: UILabel = {
        let distanceLabel = UILabel()
        distanceLabel.text = DistancelModel.getDistance(distance: DistancelModel.selectedDistance)
        distanceLabel.font = .systemFont(ofSize: CommonUtils.resizeFontSize(size: 15), weight: .regular)
        distanceLabel.textColor = .black
        distanceLabel.sizeToFit()
        return distanceLabel
    }()
    let arrowIcon: UIImageView = {
        let arrowIcon = UIImageView()
        arrowIcon.image = UIImage(systemName: "chevron.down")
        arrowIcon.tintColor = .black
        arrowIcon.isHidden = true
        return arrowIcon
    }()

    let storeButton = AroundFilterButton()
    let paymentButton = AroundFilterButton()
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.rowHeight = 110
        tableView.separatorStyle = .none
        return tableView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

//MARK: - Layout
extension AroundPlaceListView {
    /**
     * @ 초기 레이아웃 설정
     * coder : sanghyeon
     */
    func setupView() {
        if let aroundPlaceList = AroundStoreModel.list {
            filteredAroundPlaceList = aroundPlaceList
        }
        //MARK: ViewDefine
        let safeArea = safeAreaLayoutGuide
        let titleView: UIView = {
            let titleView = UIView()
            return titleView
        }()
        let addressButton: UIButton = {
            let addressButton = UIButton()
            return addressButton
        }()
        let separatorLine: UIView = {
            let separatorLine = UIView()
            separatorLine.backgroundColor = UIColor.init(hex: 0xdbdee8, alpha: 0.4)
            return separatorLine
        }()
        let filterButton: UIButton = {
            let filterButton = UIButton()
            return filterButton
        }()
        let tableWrapView: UIView = {
            let tableWrapView = UIView()
            tableWrapView.backgroundColor = .pointBlue
            return tableWrapView
        }()
        
        
        //MARK: ViewDefine
//        let AroundFilter: [Int] = [
//            AroundFilterModel.storeList.count,
//            AroundFilterModel.paymentList.count
//        ]
        
        //MARK: ViewPropertyManual
        storeButton.title = "매장선택"
        storeButton.selectedCount = 0
        paymentButton.title = "결제수단"
        paymentButton.selectedCount = 0
        
        //MARK: AddSubView
        addSubview(containerView)
        containerView.addSubview(titleView)
        titleView.addSubview(addressLabel)
        titleView.addSubview(distanceLabel)
        titleView.addSubview(arrowIcon)
        titleView.addSubview(addressButton)
        titleView.addSubview(storeButton)
        titleView.addSubview(paymentButton)
        titleView.addSubview(filterButton)
        titleView.addSubview(separatorLine)
        containerView.addSubview(tableWrapView)
        tableWrapView.addSubview(tableView)
        
        
        
        //MARK: ViewContraints
        containerView.snp.makeConstraints {
            $0.top.equalTo(safeArea).offset(32)
            $0.bottom.equalTo(safeArea)
            $0.leading.trailing.equalTo(safeArea).inset(20)
        }
        titleView.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(containerView)
            $0.bottom.equalTo(separatorLine)
        }
        addressLabel.snp.makeConstraints {
            $0.top.leading.equalTo(titleView)
        }
        distanceLabel.snp.makeConstraints {
            $0.leading.equalTo(addressLabel.snp.trailing).offset(5)
            $0.centerY.equalTo(addressLabel)
        }
        arrowIcon.snp.makeConstraints {
            $0.leading.equalTo(distanceLabel.snp.trailing).offset(5)
            $0.centerY.equalTo(distanceLabel)
        }
        addressButton.snp.makeConstraints {
            $0.top.bottom.leading.equalTo(addressLabel)
            $0.trailing.equalTo(arrowIcon)
        }
        storeButton.snp.makeConstraints {
            $0.top.equalTo(addressButton.snp.bottom).offset(10)
            $0.leading.equalTo(titleView)
            $0.width.equalTo(storeButton.buttonFrame)
            $0.height.equalTo(22)
        }
        paymentButton.snp.makeConstraints {
            $0.top.equalTo(storeButton)
            $0.leading.equalTo(storeButton.snp.trailing).offset(8)
            $0.width.equalTo(paymentButton.buttonFrame)
            $0.height.equalTo(storeButton)
        }
        filterButton.snp.makeConstraints {
            $0.top.leading.equalTo(storeButton)
            $0.trailing.bottom.equalTo(paymentButton)
        }
        separatorLine.snp.makeConstraints {
            $0.top.equalTo(storeButton.snp.bottom).offset(15)
            $0.leading.trailing.equalTo(titleView)
            $0.height.equalTo(1)
        }
        tableWrapView.snp.makeConstraints {
            $0.top.equalTo(titleView.snp.bottom)
            $0.leading.trailing.bottom.equalTo(containerView)
        }
        tableView.snp.makeConstraints {
            $0.edges.equalTo(tableWrapView)
        }
        
        
        //MARK: ViewAddTarget & Register
        tableView.register(AroundStoreTableViewCell.self, forCellReuseIdentifier: AroundStoreTableViewCell.cellId)
        //addressButton.addTarget(self, action: #selector(didTapAddressButton), for: .touchUpInside)
        filterButton.addTarget(self, action: #selector(didTapFilterButton), for: .touchUpInside)
        
        //MARK: Delegate
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    /**
     * @ 위치 버튼 클릭
     * coder : sanghyeon
     */
    @objc func didTapAddressButton() {
        delegate?.presentViewController(AroundDistanceFilterViewController())
        mainDelegate?.expendFloatingPanel()
    }
    /**
     * @ 필터버튼 클릭
     * coder : sanghyeon
     */
    @objc func didTapFilterButton() {
        let vc = AroundFilterViewController()
        vc.delegate = self
        delegate?.presentViewController(vc)
        mainDelegate?.expendFloatingPanel()
    }
}

//MARK: - TableView
extension AroundPlaceListView: UITableViewDelegate, UITableViewDataSource {
    func didTapStoreInfoButton(selectedIndex: Int?) {
        print(selectedIndex)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredAroundPlaceList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AroundStoreTableViewCell.cellId, for: indexPath) as? AroundStoreTableViewCell else { return UITableViewCell() }
        return setupCell(cell: cell, indexPath: indexPath, aroundStore: filteredAroundPlaceList[indexPath.row])
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? AroundStoreTableViewCell else { return }
        print("isUserInteractionEnabled:", cell.isUserInteractionEnabled)
    }
    
    func setupCell(cell: UITableViewCell, indexPath: IndexPath, aroundStore: AroundStores) -> UITableViewCell {
        guard let cell = cell as? AroundStoreTableViewCell else { return UITableViewCell() }
        let storeInfo = StoreInfo.convertAroundStores(aroundStore: aroundStore)
        
        cell.cellIndex = indexPath.row
        cell.storeInfo = storeInfo
        cell.isBookmark = storageViewModel.isStoreBookmark(storeInfo.storeID)
        cell.contentView.isUserInteractionEnabled = false
        cell.selectionStyle = .none
        cell.separatorInset = .zero
        
        return cell
    }
    
    
}
