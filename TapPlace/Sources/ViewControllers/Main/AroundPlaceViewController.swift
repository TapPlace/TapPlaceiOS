//
//  AroundPlaceViewController.swift
//  TapPlace
//
//  Created by 박상현 on 2022/08/17.
//

import UIKit
import FloatingPanel





class AroundPlaceViewController: UIViewController, AroundPlaceControllerProtocol, AroundDistanceFilterProtocol {
    func setDistanceLabel() {
        aroundPlaceListView.distanceLabel.text = DistancelModel.getDistance(distance: DistancelModel.selectedDistance)
    }
    
    func presentViewController(_ vc: UIViewController) {
        self.present(vc, animated: true)
    }
    

    let aroundPlaceListView = AroundPlaceListView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("현재 설정된 반경:", DistancelModel.getDistance(distance: DistancelModel.selectedDistance))
        aroundPlaceListView.distanceLabel.text = DistancelModel.getDistance(distance: DistancelModel.selectedDistance)
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
}

