//
//  ResearchButton.swift
//  TapPlace
//
//  Created by 박상현 on 2022/08/15.
//

import UIKit
protocol ResearchButtonProtocol {
    func didTapResearchButton()
}

class ResearchButton: UIView {

    var delegate: ResearchButtonProtocol?
    
    let buttonFrame: UIView = {
        let buttonFrame = UIView()
        buttonFrame.backgroundColor = .white
        return buttonFrame
    }()
    
    let refreshIcon: UIImageView = {
        let refreshIcon = UIImageView()
        refreshIcon.image = .init(named: "refresh")?.withRenderingMode(.alwaysTemplate)
        refreshIcon.tintColor = .pointBlue
        refreshIcon.contentMode = .scaleAspectFit
        return refreshIcon
    }()
    
    let buttonTitle: UILabel = {
        let buttonTitle = UILabel()
        buttonTitle.sizeToFit()
        buttonTitle.textColor = .pointBlue
        buttonTitle.text = "현 위치에서 가맹점 재탐색"
        buttonTitle.font = .systemFont(ofSize: CommonUtils.resizeFontSize(size: 14), weight: .medium)
        return buttonTitle
    }()
    
    let button: UIButton = {
        let button = UIButton()
        return button
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
        DispatchQueue.main.async {
            self.buttonFrame.layer.masksToBounds = true
            self.buttonFrame.layer.cornerRadius = self.buttonFrame.frame.size.height / 2
        }
        button.addTarget(self, action: #selector(didTestTap(_:)), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupButton() {
        addSubview(buttonFrame)
        buttonFrame.addSubview(refreshIcon)
        buttonFrame.addSubview(buttonTitle)
        addSubview(button)
        
        buttonFrame.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.equalTo(refreshIcon).offset(-15)
            $0.trailing.equalTo(buttonTitle).offset(15)
            $0.center.equalToSuperview()
        }
        refreshIcon.snp.makeConstraints {
            $0.trailing.equalTo(buttonTitle.snp.leading).offset(-7)
            $0.top.bottom.equalTo(buttonTitle)
            $0.width.equalTo(15)
        }
        buttonTitle.snp.makeConstraints {
            $0.centerY.equalTo(buttonFrame)
        }
        button.snp.makeConstraints {
            $0.edges.equalTo(buttonFrame)
        }
    }

    @objc func didTestTap(_ sender: MapButton) {
        delegate?.didTapResearchButton()
    }

}
