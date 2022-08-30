//
//  FilterResetButtonView.swift
//  TapPlace
//
//  Created by 박상현 on 2022/08/26.
//

import UIKit

class FilterResetButtonView: UIView {

    let resetLabel: UILabel = {
        let resetLabel = UILabel()
        resetLabel.sizeToFit()
        resetLabel.textColor = UIColor.init(hex: 0x333333)
        resetLabel.font = .systemFont(ofSize: CommonUtils.resizeFontSize(size: 16), weight: .medium)
        return resetLabel
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension FilterResetButtonView {
    /**
     * @ 초기 레이아웃 설정
     * coder : sanghyeon
     */
    func setupView() {
        //MARK: ViewDefine

        let resetIcon: UIImageView = {
            let resetIcon = UIImageView()
            resetIcon.image = UIImage(systemName: "arrow.clockwise")
            resetIcon.contentMode = .scaleAspectFit
            resetIcon.tintColor = resetLabel.textColor
            return resetIcon
        }()
        let resetButton: UIButton = {
            let resetButton = UIButton()
            return resetButton
        }()
        
        //MARK: ViewPropertyManual
        
        
        //MARK: AddSubView
        addSubview(resetLabel)
        addSubview(resetIcon)
        addSubview(resetButton)
        
        
        //MARK: ViewContraints
        resetLabel.snp.makeConstraints {
            $0.leading.centerY.equalToSuperview()
        }
        resetIcon.snp.makeConstraints {
            $0.centerY.equalTo(resetLabel)
            $0.leading.equalTo(resetLabel.snp.trailing).offset(10)
            $0.height.equalTo(30)
        }
        resetButton.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        
        //MARK: ViewAddTarget
        
        
        //MARK: Delegate
    }
}
