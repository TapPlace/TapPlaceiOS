//
//  MoreViewController.swift
//  TapPlace
//
//  Created by 박상현 on 2022/08/13.
//

import UIKit
import NMapsMap

class MoreViewController: UIViewController {

    let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
    }
    

}
//MARK: - Layouyt
extension MoreViewController {
    /**
     * @ 초기 레이아웃 설정
     * coder : sanghyeon
     */
    func setupView() {
        //MARK: ViewDefine
        let safeArea = view.safeAreaLayoutGuide
        
        
        //MARK: ViewPropertyManual
        self.view.backgroundColor = .white
        
        
        //MARK: AddSubView
        
        
        //MARK: ViewContraints
        
        
        //MARK: ViewAddTarget
        
        
        //MARK: Delegate
    }
    /**
     * @ 테이블뷰 세팅
     * coder : sanghyeon
     */
    func setupTableView() {
        
    }
}
