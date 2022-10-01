//
//  InquiryDetailViewController.swift
//  TapPlace
//
//  Created by 이상준 on 2022/09/30.
//

import UIKit

class InquiryDetailViewController: UIViewController {
    var noticeTitle: String? = ""
    var writeDate: String? = ""
    var content: String? = ""
    var answer: String? = ""
    var answerDate: String? = ""
    // 답변 완료 여부
    var answerCheck: Int? = 0
    
    let customNavigationBar = CustomNavigationBar()
    
    let titleLbl: UILabel = {
        let titleLbl = UILabel()
        titleLbl.sizeToFit()
        titleLbl.font = .systemFont(ofSize: 18)
        titleLbl.textColor = .init(hex: 0x4D4D4D)
        return titleLbl
    }()
    
    let acceptLbl: UILabel = {
        let acceptLbl = UILabel()
        acceptLbl.text = "접수완료"
        acceptLbl.font = .systemFont(ofSize: 12)
        acceptLbl.textColor = .init(hex: 0x9E9E9E)
        acceptLbl.layer.borderWidth = 1
        acceptLbl.layer.borderColor = .init(UIColor(hex: 0x9E9E9E).cgColor)
        acceptLbl.layer.cornerRadius = 10
        acceptLbl.textAlignment = .center
        return acceptLbl
    }()
    
    let writeDateLbl: UILabel = {
        let writeDateLbl = UILabel()
        writeDateLbl.sizeToFit()
        writeDateLbl.font = .systemFont(ofSize: 14)
        writeDateLbl.textColor = .init(hex: 0x9E9E9E)
        return writeDateLbl
    }()
    
    let contentLbl: UILabel = {
        let contentLbl = UILabel()
        contentLbl.font = .systemFont(ofSize: 15)
        contentLbl.textColor = .init(hex: 0x707070)
        contentLbl.sizeToFit()
        contentLbl.numberOfLines = 0
        return contentLbl
    }()
    
    let lineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = .init(hex: 0xDBDEE8B2)
        return lineView
    }()
    
    let responseDateLbl: UILabel = {
        let responseDateLbl = UILabel()
        responseDateLbl.textColor = .init(hex: 0x9E9E9E)
        responseDateLbl.font = .systemFont(ofSize: 14)
        responseDateLbl.sizeToFit()
        return responseDateLbl
    }()
    
    let answerLbl: UILabel = {
        let answerLbl = UILabel()
        answerLbl.sizeToFit()
        answerLbl.font = .systemFont(ofSize: 15)
        answerLbl.textColor = .init(hex: 0x707070)
        answerLbl.numberOfLines = 0
        return answerLbl
    }()
    
    let noAnwserLbl: UILabel = {
        let noAnswerLbl = UILabel()
        noAnswerLbl.text = "아직 답변이 등록되지 않았습니다"
        noAnswerLbl.font = .systemFont(ofSize: 17)
        noAnswerLbl.textColor = .init(hex: 0x707070)
        noAnswerLbl.sizeToFit()
        return noAnswerLbl
    }()
    
    override func viewDidLoad() {
        setupView()
        setLayout()
        
        customNavigationBar.delegate = self
        customNavigationBar.isDrawShadow = false
        customNavigationBar.isDrawBottomLine = false
        customNavigationBar.titleText = ""
        customNavigationBar.isUseLeftButton = true
        
        titleLbl.text = noticeTitle
        writeDateLbl.text = writeDate
        contentLbl.text = content
        answerLbl.text = answer
        
        if let answerDate = answerDate {
            responseDateLbl.text = "답변완료일: \(answerDate)"
        }
        DispatchQueue.main.async {
            self.changeUI()
        }
    }
}

extension InquiryDetailViewController {
    private func setupView() {
        self.view.backgroundColor = .white
    }
    
    private func setLayout() {
        view.addSubview(customNavigationBar)
        customNavigationBar.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(customNavigationBar.containerView)
        }
        
        view.addSubview(titleLbl)
        titleLbl.snp.makeConstraints {
            $0.top.equalTo(customNavigationBar.snp.bottom).offset(15)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
        }
        
        view.addSubview(acceptLbl)
        acceptLbl.snp.makeConstraints {
            $0.top.equalTo(titleLbl.snp.bottom).offset(8)
            $0.leading.equalToSuperview().offset(20)
            $0.width.equalTo(66)
            $0.height.equalTo(22)
        }
        
        view.addSubview(writeDateLbl)
        writeDateLbl.snp.makeConstraints {
            $0.top.equalTo(titleLbl.snp.bottom).offset(10)
            $0.leading.equalTo(acceptLbl.snp.trailing).offset(6)
        }
        
        view.addSubview(contentLbl)
        contentLbl.snp.makeConstraints {
            $0.top.equalTo(writeDateLbl.snp.bottom).offset(13)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
        }
        
        view.addSubview(lineView)
        lineView.snp.makeConstraints {
            $0.top.equalTo(contentLbl.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.height.equalTo(1)
        }
        
        view.addSubview(responseDateLbl)
        responseDateLbl.snp.makeConstraints {
            $0.top.equalTo(lineView.snp.bottom).offset(28)
            $0.leading.equalToSuperview().offset(20)
        }
        
        view.addSubview(answerLbl)
        answerLbl.snp.makeConstraints {
            $0.top.equalTo(responseDateLbl.snp.bottom).offset(12)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
        }
    }
    
    // 답변완료되었을 경우
    private func changeUI() {
        if answerCheck == 1 {
            acceptLbl.text = "답변완료"
            acceptLbl.textColor = .init(hex: 0x4E77FB)
            acceptLbl.layer.borderWidth = 1
            acceptLbl.layer.borderColor = UIColor.init(hex: 0x4E77FB).cgColor
            acceptLbl.backgroundColor = .white
            acceptLbl.layer.cornerRadius = 10
            acceptLbl.layer.masksToBounds = true
            acceptLbl.backgroundColor = .init(hex: 0xF4F7FF)
        } else {
            responseDateLbl.text = ""
            
            answerLbl.addSubview(noAnwserLbl)
            noAnwserLbl.snp.makeConstraints {
                $0.center.equalToSuperview()
            }
        }
    }
}

// MARK: - 커스텀 네비게이션 바 프로토콜 구현
extension InquiryDetailViewController: CustomNavigationBarProtocol {
    func didTapLeftButton() {
        self.navigationController?.popViewController(animated: true)
    }
}

