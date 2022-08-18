//
//  AroundPlaceViewController.swift
//  TapPlace
//
//  Created by 박상현 on 2022/08/17.
//

import UIKit
import FloatingPanel

protocol AroundPlaceVCProtocol {
    func showFloatingPanel(type: FloatingPanelState)
}

class AroundPlaceViewController: UIViewController, AroundFilterButtonProtocol {
    static var delegate: AroundPlaceVCProtocol?
    
    func didTapAroundFilterButton(_ sender: AroundFilterButton) {
        AroundPlaceViewController.delegate?.showFloatingPanel(type: .full)
    }
    
    let containerView: UIView = {
        let containerView = UIView()
        containerView.backgroundColor = .clear
        return containerView
    }()
    let pickStoreButton = AroundFilterButton()
    let pickPaymemtButton = AroundFilterButton()
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorColor = .white
        tableView.rowHeight = 90
        tableView.register(AroundStoreTableViewCell.self, forCellReuseIdentifier: AroundStoreTableViewCell.cellId)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

}

extension AroundPlaceViewController {
    /**
     * @ 초기 레이아웃 설정
     * coder : sanghyeon
     */
    func setupView() {
        //MARK: ViewDefine
        let safeArea = view.safeAreaLayoutGuide
        let locationView: UIView = {
            let locationView = UIView()
            return locationView
        }()
        let locationLabel: UILabel = {
            let locationLabel = UILabel()
            locationLabel.text = "강서구 등촌3동 주변"
            locationLabel.sizeToFit()
            locationLabel.textColor = .black
            locationLabel.font = .systemFont(ofSize: CommonUtils.resizeFontSize(size: 15), weight: .semibold)
            return locationLabel
        }()
        let distanceLabel: UILabel = {
            let distanceLabel = UILabel()
            distanceLabel.text = "1km"
            distanceLabel.sizeToFit()
            distanceLabel.textColor = .black
            distanceLabel.font = locationLabel.font
            return distanceLabel
        }()
        let locationArrowImage: UIImageView = {
            let locationArrowImage = UIImageView()
            locationArrowImage.image = UIImage(systemName: "chevron.down")
            locationArrowImage.tintColor = .black
            locationArrowImage.contentMode = .scaleAspectFit
            return locationArrowImage
        }()
        let locationButton: UIButton = {
            let locationButton = UIButton()
            return locationButton
        }()
        let separatorLine: UIView = {
            let separatorLine = UIView()
            separatorLine.backgroundColor = UIColor.init(hex: 0xdbdee8, alpha: 0.4)
            return separatorLine
        }()
        

        
        //MARK: ViewPropertyManual
        pickStoreButton.title = "매장선택"
        pickPaymemtButton.title = "결제수단"
        pickPaymemtButton.selectedCount = 5
        
        
        
        //MARK: AddSubView
        view.addSubview(containerView)
        containerView.addSubview(locationView)
        locationView.addSubview(locationLabel)
        locationView.addSubview(distanceLabel)
        locationView.addSubview(locationArrowImage)
        locationView.addSubview(locationButton)
        containerView.addSubview(pickStoreButton)
        containerView.addSubview(pickPaymemtButton)
        containerView.addSubview(separatorLine)
        containerView.addSubview(tableView)
        
        
        //MARK: ViewContraints
        containerView.snp.makeConstraints {
            $0.leading.trailing.equalTo(safeArea).inset(20)
            $0.top.bottom.equalTo(safeArea).inset(20)
        }
        locationView.snp.makeConstraints {
            $0.top.bottom.leading.equalTo(locationLabel)
            $0.trailing.equalTo(locationArrowImage)
        }
        locationLabel.snp.makeConstraints {
            $0.top.leading.equalTo(containerView)
        }
        distanceLabel.snp.makeConstraints {
            $0.centerY.equalTo(locationLabel)
            $0.height.equalTo(locationLabel)
            $0.leading.equalTo(locationLabel.snp.trailing).offset(5)
        }
        locationArrowImage.snp.makeConstraints {
            $0.centerY.equalTo(distanceLabel)
            $0.leading.equalTo(distanceLabel.snp.trailing).offset(5)
            $0.height.equalTo(distanceLabel)
        }
        locationButton.snp.makeConstraints {
            $0.edges.equalTo(locationView)
        }
        pickStoreButton.snp.makeConstraints {
            $0.top.equalTo(locationView.snp.bottom).offset(10)
            $0.width.equalTo(pickStoreButton.buttonFrame)
            $0.leading.equalTo(containerView)
        }
        pickPaymemtButton.snp.makeConstraints {
            $0.leading.equalTo(pickStoreButton.snp.trailing).offset(5)
            $0.width.equalTo(pickPaymemtButton.buttonFrame)
            $0.top.equalTo(pickStoreButton)
        }
        separatorLine.snp.makeConstraints {
            $0.top.equalTo(pickStoreButton.snp.bottom).offset(15)
            $0.leading.trailing.equalTo(containerView)
            $0.height.equalTo(1)
        }
        tableView.snp.makeConstraints {
            $0.top.equalTo(separatorLine).offset(15)
            $0.leading.trailing.bottom.equalTo(containerView)
        }
        
        
        //MARK: ViewAddTarget
        locationButton.addTarget(self, action: #selector(didTapLocation), for: .touchUpInside)
        
        //MARK: Delegate
        pickStoreButton.delegate = self
        pickPaymemtButton.delegate = self
        pickStoreButton.delegate = self
        pickPaymemtButton.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    @objc func didTapLocation() {
        print("로케이션 버튼 클릭")
    }
}

//MARK: - TableView
extension AroundPlaceViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AroundStoreTableViewCell.cellId, for: indexPath) as! AroundStoreTableViewCell
        cell.setAttributedString(distance: "50m", paySuccess: "90", payFail: "10")
        cell.payLists = ["applelogo", "cart.fill", "trash.fill"]
        cell.selectionStyle = .none
        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? AroundStoreTableViewCell else { return }
        print("선택된 셀의 타이틀:", cell.storeLabel.text, ", 셀 높이:", cell.containerView.frame.height)
    }
    
    
    
}
