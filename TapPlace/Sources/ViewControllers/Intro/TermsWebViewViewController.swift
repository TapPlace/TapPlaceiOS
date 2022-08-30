//
//  TermsWebViewViewController.swift
//  TapPlace
//
//  Created by 박상현 on 2022/08/26.
//

import UIKit
import WebKit

protocol TermsProtocol {
    func checkReceiveTerm(term: TermsModel, currentTermIndex: Int)
}

class TermsWebViewViewController: UIViewController {

    var delegate: TermsProtocol?
    var term: TermsModel?
    var termIndex: Int = 0
    
    let bottomButton = BottomButton()
    let navigationBar = NavigationBar()
    var webViewFrame = UIView()
    var webView: WKWebView!
    
    override func loadView() {
        super.loadView()
        webView = WKWebView(frame: self.webViewFrame.frame)
        self.webViewFrame = self.webView!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        guard let term = term else { return }
        checkTerm(term: term)
        loadTermsWeb(term: term)
    }
    

}

extension TermsWebViewViewController: BackButtonProtocol, UIScrollViewDelegate, BottomButtonProtocol {
    func didTapBottomButton() {
        if bottomButton.isActive == false { return }
        /// Bool값 변경
        term?.read = true
        term?.checked = true
        /// 옵셔널 바인딩
        guard let term = term else { return }
        delegate?.checkReceiveTerm(term: term, currentTermIndex: termIndex)
        self.navigationController?.popViewController(animated: true)
    }
    
    func popViewVC() {
        /// 네비게이션바로 돌아갈때는 체크여부 해제
        term?.read = false
        term?.checked = false
        guard let term = term else { return }
        delegate?.checkReceiveTerm(term: term, currentTermIndex: termIndex)
        self.navigationController?.popViewController(animated: true)
    }
    
    /**
     * @ 초기 레이아웃 설정
     * coder : sanghyeon
     */
    func setupView() {
        //MARK: ViewDefine
        let safeArea = view.safeAreaLayoutGuide
        guard let term = term else { return }

        
        //MARK: ViewPropertyManual
        view.backgroundColor = .white
        navigationBar.title = term.title
        bottomButton.setButtonStyle(title: "동의", type: .disabled, fill: true)
        
        //MARK: AddSubView
        view.addSubview(navigationBar)
        view.addSubview(webViewFrame)
        view.addSubview(bottomButton)
        
        
        
        //MARK: ViewContraints
        navigationBar.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(safeArea)
            $0.height.equalTo(60)
        }
        webViewFrame.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.bottom.equalTo(bottomButton.snp.top)
            $0.leading.trailing.equalTo(safeArea)
        }
        bottomButton.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.leading.trailing.equalTo(safeArea)
            $0.top.equalTo(safeArea.snp.bottom).offset(-50)
        }
        
        //MARK: ViewAddTarget
        
        
        //MARK: Delegate
        navigationBar.delegate = self
        bottomButton.delegate = self
        webView.scrollView.delegate = self
    }
    
    /**
     * @ 올바른 약관이 넘어왔는지 확인 후 비정상시 뷰 닫기
     * coder : sanghyeon
     */
    func checkTerm(term: TermsModel) {
        if term.link == "" {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    /**
     * @ 약관 페이지 불러오기
     * coder : sanghyeon
     */
    func loadTermsWeb(term: TermsModel) {
        let tURL = URL(string: Constants.tapplaceBaseUrl + "/tapplace" + term.link)
        var request = URLRequest(url: tURL!)
        webView.load(request)
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y >= (scrollView.contentSize.height - scrollView.frame.size.height) {
            bottomButton.setButtonStyle(title: "동의", type: .activate, fill: true)
            bottomButton.isActive = true
        }
    }
    
}
