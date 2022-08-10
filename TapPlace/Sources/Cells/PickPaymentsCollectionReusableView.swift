//
//  PickPaymentsCollectionReusableView.swift
//  TapPlace
//
//  Created by 박상현 on 2022/08/09.
//

import UIKit

class PickPaymentsCollectionReusableView: UICollectionReusableView {

    private let titleText: UILabel = {
        let titleText = UILabel()
        titleText.textColor = UIColor.init(hex: 0x000000, alpha: 0.6)
        titleText.font = .systemFont(ofSize: CommonUtils().resizeFontSize(size: 16), weight: .regular)
        return titleText
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(titleText)
        
        titleText.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-10)
        }

    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.prepare(title: nil)
    }
    
    func prepare(title: String?) {
        self.titleText.text = title
    }
    
    
    
}
