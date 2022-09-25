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
    var storageViewModel = StorageViewModel()
    var term: TermsModel?
    var termIndex: Int = 0
    var isExistUser: Bool = false
    
    var isReadOnly: Bool = false {
        willSet {
            let safeArea = view.safeAreaLayoutGuide
            if newValue {
                bottomButton.isHidden = true
                webViewFrame.snp.remakeConstraints {
                    $0.top.equalTo(customNavigationBar.snp.bottom)
                    $0.bottom.equalTo(safeArea)
                    $0.leading.trailing.equalTo(safeArea)
                }
                customNavigationBar.isUseLeftButton = true
                customNavigationBar.delegate = self
            } else {
                bottomButton.isHidden = false
                webViewFrame.snp.remakeConstraints {
                    $0.top.equalTo(customNavigationBar.snp.bottom)
                    $0.bottom.equalTo(bottomButton.snp.top)
                    $0.leading.trailing.equalTo(safeArea)
                }
                customNavigationBar.isUseLeftButton = false
            }
        }
    }
    
    let bottomButton = BottomButton()
    let customNavigationBar = CustomNavigationBar()
    var webViewFrame = UIView()
    var webView: WKWebView!
    
    override func loadView() {
        super.loadView()
        webView = {
            let configuration = WKWebViewConfiguration()
            let source: String = "var meta = document.createElement('meta');" +
                "meta.name = 'viewport';" +
                "meta.content = 'width=device-width, initial-scale=0.7, maximum-scale=0.7, user-scalable=no';" +
                "var head = document.getElementsByTagName('head')[0];" +
                "head.appendChild(meta);"
            let script: WKUserScript = WKUserScript(source: source, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
            configuration.userContentController.addUserScript(script)
            let webView = WKWebView(frame: self.webViewFrame.frame, configuration: configuration)
            webView.evaluateJavaScript("navigator.userAgent") { (result, error) in
                let originUserAgent = result as! String
                let agent = "\(originUserAgent)/TAPPLACE_APP"
                self.webView.customUserAgent = agent
            }
            return webView
        }()
        
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

extension TermsWebViewViewController: CustomNavigationBarProtocol, UIScrollViewDelegate, BottomButtonProtocol {
    
    func didTapBottomButton() {
        if bottomButton.isActive == false { return }
        /// Bool값 변경
        term?.read = true
        term?.checked = true
        /// 옵셔널 바인딩
        guard let term = term else { return }
        switch term.title {
        case "서비스 이용약관":
            let parameter = [
                "service_date": LatestTermsModel.latestServiceDate
            ]
            
            self.delegate?.checkReceiveTerm(term: term, currentTermIndex: self.termIndex)
            UserRegisterModel.setUser.serviceDate = LatestTermsModel.latestServiceDate
            if isExistUser {
                UserDataService().requestFetchUpdateUser(parameter: parameter, header: Constants().header) { result in
                    self.navigationController?.popViewController(animated: true)
                }
            }
        case "개인정보 수집 및 이용동의":
            let parameter = [
                "personal_date": LatestTermsModel.latestPersonalDate,
                "key": Constants.tapplaceApiKey
            ]
            self.delegate?.checkReceiveTerm(term: term, currentTermIndex: self.termIndex)
            UserRegisterModel.setUser.personalDate = LatestTermsModel.latestPersonalDate
            if isExistUser {
                UserDataService().requestFetchUpdateUser(parameter: parameter, header: Constants().header) { result in
                    self.navigationController?.popViewController(animated: true)
                }
            }
        default: break
        }
        
    }
    
    func didTapLeftButton() {
        /// 네비게이션바로 돌아갈때는 체크여부 해제
        if !isReadOnly {
            term?.read = false
            term?.checked = false
            guard let term = term else { return }
            delegate?.checkReceiveTerm(term: term, currentTermIndex: termIndex)
        }
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
        customNavigationBar.titleText = term.title
        bottomButton.setButtonStyle(title: "동의", type: .disabled, fill: true)
        
        //MARK: AddSubView
        view.addSubview(customNavigationBar)
        view.addSubview(webViewFrame)
        view.addSubview(bottomButton)
        
        
        
        //MARK: ViewContraints
        customNavigationBar.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(safeArea)
            $0.height.equalTo(60)
        }
        webViewFrame.snp.makeConstraints {
            $0.top.equalTo(customNavigationBar.snp.bottom)
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
        customNavigationBar.delegate = self
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
        let tURL = URL(string: term.link)
        let request = URLRequest(url: tURL!)
        webView.load(request)
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if isReadOnly { return }
        if scrollView.contentOffset.y >= (scrollView.contentSize.height - scrollView.frame.size.height - 300) {
            bottomButton.setButtonStyle(title: "동의", type: .activate, fill: true)
            bottomButton.isActive = true
        }
    }
    
}
