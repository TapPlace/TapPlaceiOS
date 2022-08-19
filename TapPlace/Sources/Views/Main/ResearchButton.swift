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
        let buttonFrame = UILabel()
        buttonFrame.backgroundColor = .white
        return buttonFrame
    }()
    
    let buttonTitle: UILabel = {
        let buttonTitle = UILabel()
        buttonTitle.sizeToFit()
        buttonTitle.textColor = .pointBlue
        buttonTitle.text = "현 지도에서 검색"
        buttonTitle.font = .systemFont(ofSize: CommonUtils.resizeFontSize(size: 14), weight: .regular)
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
        buttonFrame.addSubview(buttonTitle)
        addSubview(button)
        
        buttonFrame.snp.makeConstraints {
            $0.top.bottom.leading.trailing.equalToSuperview()
            $0.center.equalToSuperview()
        }
        buttonTitle.snp.makeConstraints {
            $0.center.equalTo(buttonFrame)
        }
        button.snp.makeConstraints {
            $0.top.bottom.leading.trailing.equalTo(buttonFrame)
        }
    }

    @objc func didTestTap(_ sender: MapButton) {
        delegate?.didTapResearchButton()
    }

}
