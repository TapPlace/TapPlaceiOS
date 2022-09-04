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
    func applyFilter() {
        let AroundFilter: [Int] = [
            AroundFilterModel.storeList.count,
            AroundFilterModel.paymentList.count
        ]
        storeButton.selectedCount = AroundFilter[0]
        paymentButton.selectedCount = AroundFilter[1]
    }
    
    var delegate: AroundPlaceControllerProtocol?
    var mainDelegate: AroundPlaceMainControllerProtocol?
    
    let containerView: UIView = {
        let containerView = UIView()
        return containerView
    }()
    let addressLabel: UILabel = {
        let addressLabel = UILabel()
        addressLabel.text = "강서구 등촌3동 주변"
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
        //tableView.estimatedRowHeight = 80
        tableView.separatorStyle = .singleLine
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
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
        let AroundFilter: [Int] = [
            AroundFilterModel.storeList.count,
            AroundFilterModel.paymentList.count
        ]
        
        //MARK: ViewPropertyManual
        storeButton.title = "매장선택"
        storeButton.selectedCount = AroundFilter[0]
        paymentButton.title = "결제수단"
        paymentButton.selectedCount = AroundFilter[1]
        
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
extension AroundPlaceListView: UITableViewDelegate, UITableViewDataSource, StoreInfoViewButtonProtocol {
    func didTapStoreInfoButton(selectedIndex: Int?) {
        print(selectedIndex)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AroundStoreTableViewCell.cellId, for: indexPath) as? AroundStoreTableViewCell else { return UITableViewCell() }
        let bookmark = indexPath.row == 2 ? true : false
        
        cell.cellIndex = indexPath.row
        cell.storeInfoView.setAttributedString(store: "[\(indexPath.row)] 세븐일레븐 염창점",distance: "50m", address: "서울특별시 강서구 양천로 677", isBookmark: bookmark)
        cell.storeInfoView.payLists = ["applelogo", "cart.fill", "trash.fill"]
        cell.storeInfoView.isButtonVisible = true
        cell.storeInfoView.delegate = self
        cell.contentView.isUserInteractionEnabled = false
        cell.selectionStyle = .none
        cell.separatorInset = .zero
        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? AroundStoreTableViewCell else { return }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110//UITableView.automaticDimension
    }
    
}
