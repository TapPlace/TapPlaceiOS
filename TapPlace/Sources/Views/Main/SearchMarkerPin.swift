//
//  SearchMarkerPin.swift
//  TapPlace
//
//  Created by 박상현 on 2022/09/14.
//

import UIKit

class SearchMarkerPin: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension SearchMarkerPin {
    func setupView() {
        let markerPin = UIView()
        let dot: UIView = {
            let dot = UIView()
            dot.backgroundColor = .init(hex: 0x333333)
            dot.layer.cornerRadius = 4
            return dot
        }()
        let pillar: UIView = {
            let pillar = UIView()
            pillar.backgroundColor = .init(hex: 0x333333)
            return pillar
        }()
        let balloon: UIView = {
            let balloon = UIView()
            balloon.backgroundColor = .init(hex: 0x333333)
            balloon.layer.cornerRadius = 15
            return balloon
        }()
        let text: UILabel = {
            let text = UILabel()
            text.sizeToFit()
            text.text = "탐색기준"
            text.font = .systemFont(ofSize: CommonUtils.resizeFontSize(size: 13), weight: .semibold)
            text.textColor = .white
            return text
        }()
        
        markerPin.addSubview(dot)
        markerPin.addSubview(pillar)
        markerPin.addSubview(balloon)
        balloon.addSubview(text)
        addSubview(markerPin)
        
        dot.snp.makeConstraints {
            $0.width.height.equalTo(8)
            $0.centerX.equalTo(markerPin)
            $0.bottom.equalTo(markerPin.snp.top)
        }
        pillar.snp.makeConstraints {
            $0.width.equalTo(2)
            $0.height.equalTo(22)
            $0.bottom.equalTo(dot).offset(-4)
            $0.centerX.equalTo(dot)
        }
        balloon.snp.makeConstraints {
            $0.height.equalTo(30)
            $0.centerX.equalTo(pillar)
            $0.bottom.equalTo(pillar.snp.top).offset(2)
            $0.leading.equalTo(text).offset(-10)
            $0.trailing.equalTo(text).offset(10)
        }
        text.snp.makeConstraints {
            $0.center.equalTo(balloon)
        }
        markerPin.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
