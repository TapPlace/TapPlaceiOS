//
//  AroundPlaceViewController.swift
//  TapPlace
//
//  Created by 박상현 on 2022/08/17.
//

import UIKit
import FloatingPanel





class AroundPlaceViewController: UIViewController {

    let aroundPlaceListView = AroundPlaceListView()
    
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
        
        
        //MARK: ViewPropertyManual
        
        
        //MARK: AddSubView
        view.addSubview(aroundPlaceListView)
        
        
        //MARK: ViewContraints
        aroundPlaceListView.snp.makeConstraints {
            $0.edges.equalTo(safeArea)
        }
        
        //MARK: ViewAddTarget
        
        
        //MARK: Delegate

        
    }
}

