//
//  AroundPlaceViewController.swift
//  TapPlace
//
//  Created by 박상현 on 2022/08/17.
//

import UIKit
import Combine
import FloatingPanel
import CoreLocation

class AroundPlaceViewController: UIViewController, AroundPlaceControllerProtocol, AroundDistanceFilterProtocol {
    func showFilterView() {
        let vc = AroundFilterViewController()
        self.present(vc, animated: true)
    }
    
    func setDistanceLabel() {
        aroundPlaceListView.distanceLabel.text = DistancelModel.getDistance(distance: DistancelModel.selectedDistance)
    }
    
    func presentViewController(_ vc: UIViewController) {
        self.present(vc, animated: true)
    }
    

    var storeViewModel: StoreViewModel? = nil {
        willSet {
            print("*** AroundPlaceVC, storeViewModel, willSet, newValue = \(newValue)")
            if let storeVM = newValue {
                print("*** AroundPlaceVC, storeViewModel, willSet, newValue OptionalBinding = \(storeVM)")
                aroundPlaceListView.storeViewModel = storeVM
            }
        }
    }
    var disposalbleBag = Set<AnyCancellable>()
    let aroundPlaceListView = AroundPlaceListView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBindings()
        setupView()
        guard let camLocation = UserInfo.cameraLocation else { return }
        storeViewModel?.requestGeoAddress(location: camLocation)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        aroundPlaceListView.storeButton.selectedCount = AroundFilterModel.storeList.count
        aroundPlaceListView.paymentButton.selectedCount = AroundFilterModel.paymentList.count
//        AroundFilterModel.storeList.removeAll()
//        AroundFilterModel.paymentList.removeAll()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        aroundPlaceListView.distanceLabel.text = DistancelModel.getDistance(distance: DistancelModel.selectedDistance)
//        AroundFilterModel.storeList.removeAll()
//        AroundFilterModel.paymentList.removeAll()
    }
}

extension AroundPlaceViewController {
    /**
     * @ 뷰모델 데이터 바인딩
     * coder : sanghyeon
     */
    func setBindings() {
        self.storeViewModel?.$userLocationGeoAddress.sink { (address: String) in
            self.aroundPlaceListView.address = address
        }.store(in: &disposalbleBag)
    }
    /**
     * @ 초기 레이아웃 설정
     * coder : sanghyeon
     */
    func setupView() {
        //MARK: ViewDefine
        let safeArea = view.safeAreaLayoutGuide
        
        
        //MARK: ViewPropertyManual
        if let storeViewModel = self.storeViewModel {
            aroundPlaceListView.storeViewModel = storeViewModel
        }
        
        
        //MARK: AddSubView
        view.addSubview(aroundPlaceListView)
        
        
        //MARK: ViewContraints
        aroundPlaceListView.snp.makeConstraints {
            $0.edges.equalTo(safeArea)
        }
        
        //MARK: ViewAddTarget
        
        
        //MARK: Delegate
        AroundDistanceFilterViewController.delegate = self
        aroundPlaceListView.delegate = self
    }
}

