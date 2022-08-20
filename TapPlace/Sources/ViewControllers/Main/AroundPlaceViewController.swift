//
//  AroundPlaceViewController.swift
//  TapPlace
//
//  Created by 박상현 on 2022/08/17.
//

import UIKit
import FloatingPanel





class AroundPlaceViewController: UIViewController, AroundPlaceViewProtocol, AroundFilterViewProtocol {
    func showFilterView(show: Bool) {
        guard let tabBar = tabBarController as? TabBarViewController else { return }
        if show {
            view.addSubview(aroundPlaceFilterView)
            aroundPlaceFilterView.snp.makeConstraints {
                $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
                $0.bottom.equalToSuperview()
            }
            tabBar.showTabBar(hide: true)
        } else {
            aroundPlaceFilterView.removeFromSuperview()
            tabBar.showTabBar(hide: false)
            AroundPlaceListView.delegate?.hideGrabber(hide: false)
        }
    }
    
    let aroundPlaceListView = AroundPlaceListView()
    let aroundPlaceFilterView = AroundPlaceFilterView()

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
        AroundPlaceListView.viewDelegate = self
        AroundPlaceFilterView.viewDelegate = self
    }
}

//MARK: - TableView
extension AroundPlaceViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AroundStoreTableViewCell.cellId, for: indexPath) as! AroundStoreTableViewCell
        cell.setAttributedString(distance: "50m", address: "서울특별시 강서구 양천로 677")
        cell.payLists = ["applelogo", "cart.fill", "trash.fill"]
        cell.selectionStyle = .none
        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? AroundStoreTableViewCell else { return }
        print("선택된 셀의 타이틀:", cell.storeLabel.text, ", 셀 높이:", cell.containerView.frame.height)
    }
    
    
    
    
    
}
