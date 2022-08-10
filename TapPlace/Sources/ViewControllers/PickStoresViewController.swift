//
//  PickStoresViewController.swift
//  TapPlace
//
//  Created by 박상현 on 2022/08/09.
//

import UIKit

class PickStoresViewController: UIViewController {

    let titleView = PickViewControllerTitleView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        // Do any additional setup after loading the view.
    }
    



}

//MARK: - Layout
extension PickStoresViewController: TitleViewProtocol {
    func didTapTitleViewSkipButton() {
        print("스킵 버튼 눌림")
    }
    
    func didTapTitleViewClearButton() {
        print("초기화 버튼 눌림")
    }
    
    /**
     * @ 초기 레이아웃 설정
     * coder : sanghyeon
     */
    private func setupView() {
        /// 뷰컨트롤러 배경색 지정
        view.backgroundColor = .white
        //MARK: 뷰 추가
        view.addSubview(titleView)
        //MARK: 뷰 제약
        titleView.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(230)
        }
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        titleView.titleViewText.text = "관심 매장 선택"
        titleView.currentPage = 2
        titleView.descLabel.text = "선호하는 매장을 선택하면,\n해당 매장의 간편결제 여부를 알려드릴게요."
        titleView.delegate = self
    }
}
