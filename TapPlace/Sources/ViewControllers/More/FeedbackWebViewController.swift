//
//  FeedbackWebViewController.swift
//  TapPlace
//
//  Created by 박상현 on 2022/09/17.
//

import UIKit
import WebKit

class FeedbackWebViewController: UIViewController {
    
    let customNavigationBar = CustomNavigationBar()
    var webViewFrame = UIView()
    var webView = WKWebView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func loadView() {
        super.loadView()
        setupWebView()
    }


}
extension FeedbackWebViewController: CustomNavigationBarProtocol {
    func didTapLeftButton() {
        self.navigationController?.popViewController(animated: true)
    }
    
    // https://tapplace.notion.site/iOS-33a677b70d4240329aee2d37b6c31047
    /**
     * @ 초기 레이아웃 설정
     * coder : sanghyeon
     */
    func setupView() {
        //MARK: ViewDefine
        let safeArea = view.safeAreaLayoutGuide
        
        
        //MARK: ViewPropertyManual
        view.backgroundColor = .white
        customNavigationBar.titleText = "피드백 현황"
        customNavigationBar.isUseLeftButton = true
        
        
        //MARK: AddSubView
        view.addSubview(customNavigationBar)
        view.addSubview(webViewFrame)
        
        
        //MARK: ViewContraints
        customNavigationBar.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(customNavigationBar.containerView)
        }
        webViewFrame.snp.makeConstraints {
            $0.leading.trailing.bottom.equalTo(safeArea)
            $0.top.equalTo(customNavigationBar.snp.bottom)
        }
        
        //MARK: ViewAddTarget
        
        
        //MARK: Delegate
        customNavigationBar.delegate = self
    }
    /**
     * @ 웹뷰 설정
     * coder : sanghyeon
     */
    func setupWebView() {
        webView = {
            let webView = WKWebView(frame: webViewFrame.frame)
            return webView
        }()
        if let url = URL(string: "https://tapplace.notion.site/iOS-33a677b70d4240329aee2d37b6c31047") {
            let request = URLRequest(url: url)
            webView.load(request)
        }
        webViewFrame = webView
    }
}
