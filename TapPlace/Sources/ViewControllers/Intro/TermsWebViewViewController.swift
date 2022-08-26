//
//  TermsWebViewViewController.swift
//  TapPlace
//
//  Created by 박상현 on 2022/08/26.
//

import UIKit
import WebKit

class TermsWebViewViewController: UIViewController {

    var term: TermsModel?
    
    let bottomButton = BottomButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

    }
    

}

extension TermsWebViewViewController {
    /**
     * @ 초기 레이아웃 설정
     * coder : sanghyeon
     */
    func setupView() {
        //MARK: ViewDefine
        let safeArea = view.safeAreaLayoutGuide
        guard let term = term else { return }
        print(term)
        
        //MARK: ViewPropertyManual
        view.backgroundColor = .white
        
        //MARK: AddSubView
        
        
        //MARK: ViewContraints
        
        
        //MARK: ViewAddTarget
        
        
        //MARK: Delegate
    }
}
