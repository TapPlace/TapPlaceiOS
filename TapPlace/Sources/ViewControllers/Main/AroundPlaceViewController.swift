//
//  AroundPlaceViewController.swift
//  TapPlace
//
//  Created by 박상현 on 2022/08/17.
//

import UIKit
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
    

    var storeViewModel = StoreViewModel()
    let aroundPlaceListView = AroundPlaceListView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        guard let camLocation = UserInfo.cameraLocation else { return }
        getGeoAddress(location: camLocation)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AroundFilterModel.storeList.removeAll()
        AroundFilterModel.paymentList.removeAll()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        aroundPlaceListView.distanceLabel.text = DistancelModel.getDistance(distance: DistancelModel.selectedDistance)
        AroundFilterModel.storeList.removeAll()
        AroundFilterModel.paymentList.removeAll()
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
        
        
        //MARK: ViewPropertyManual
        
        
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
    /**
     * @ 좌표주소로 행정주소 가져오기
     * coder : sanghyeon
     */
    func getGeoAddress(location: CLLocationCoordinate2D) {
        storeViewModel.requestGeoAddress(location: location) { result in
            var address = ""
            if let roadAddress = result.documents[0].roadAddress {
                address = "\(roadAddress.region2DepthName) \(roadAddress.roadName)"
            } else {
                let baseAddress = result.documents[0].address
                address = "\(baseAddress.region2DepthName) \(baseAddress.region3DepthName)"
            }
            self.aroundPlaceListView.address = address
        }
    }
}

