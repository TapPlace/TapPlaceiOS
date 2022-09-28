//
//  NoticeDetailViewController.swift
//  TapPlace
//
//  Created by 이상준 on 2022/09/26.
//

import Foundation
import UIKit

class NoticeDetailViewController: UIViewController {
    
    var noticeTitle: String? = ""
    var writeDate: String? = ""
    var content: String? = ""
    
    let customNavigationBar = CustomNavigationBar()
    
    let noticeTitleLbl: UILabel = {
        let noticeTitleLbl = UILabel()
        noticeTitleLbl.sizeToFit()
        noticeTitleLbl.font = .systemFont(ofSize: 18)
        noticeTitleLbl.textColor = .init(hex: 0x4D4D4D)
        return noticeTitleLbl
    }()
    
    let writeDateLbl: UILabel = {
        let writeDateLbl = UILabel()
        writeDateLbl.sizeToFit()
        writeDateLbl.font = .systemFont(ofSize: 14)
        writeDateLbl.textColor = .init(hex: 0x9E9E9E)
        return writeDateLbl
    }()
    
    let lineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = .init(hex: 0xDBDEE8B2)
        return lineView
    }()
    
    let contentLbl: UILabel = {
        let contentLbl = UILabel()
        contentLbl.sizeToFit()
        contentLbl.font = .systemFont(ofSize: 15)
        contentLbl.textColor = .init(hex: 0x707070)
        contentLbl.numberOfLines = 0
        return contentLbl
    }()
    
    
    override func viewDidLoad() {
        setupView()
        setLayout()
        
        customNavigationBar.delegate = self
        customNavigationBar.isDrawShadow = false
        customNavigationBar.isDrawBottomLine = false
        customNavigationBar.titleText = "공지사항"
        customNavigationBar.isUseLeftButton = true
        
        noticeTitleLbl.text = noticeTitle
        writeDateLbl.text = writeDate
        contentLbl.text = content
    }
}

extension NoticeDetailViewController {
    private func setupView() {
        self.view.backgroundColor = .white
    }
    
    private func setLayout() {
        view.addSubview(customNavigationBar)
        customNavigationBar.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(customNavigationBar.containerView)
        }
        
        view.addSubview(noticeTitleLbl)
        noticeTitleLbl.snp.makeConstraints {
            $0.top.equalTo(customNavigationBar.snp.bottom).offset(15)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
        }
        
        view.addSubview(writeDateLbl)
        writeDateLbl.snp.makeConstraints {
            $0.top.equalTo(noticeTitleLbl.snp.bottom).offset(8)
            $0.leading.equalToSuperview().offset(20)
        }
        
        view.addSubview(lineView)
        lineView.snp.makeConstraints {
            $0.top.equalTo(writeDateLbl.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.height.equalTo(1)
        }
        
        view.addSubview(contentLbl)
        contentLbl.snp.makeConstraints {
            $0.top.equalTo(lineView.snp.bottom).offset(28)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
        }
    }
}

// MARK: - 커스텀 네비게이션 바 프로토콜 구현
extension NoticeDetailViewController: CustomNavigationBarProtocol {
    func didTapLeftButton() {
        self.navigationController?.popViewController(animated: true)
    }
}
