//
//  DetailToolBarButton.swift
//  TapPlace
//
//  Created by 박상현 on 2022/08/16.
//

import UIKit

protocol DetailToolBarButtonProtocol {
    func didTapToolBarButton(_ sender: UIButton)
}

class DetailToolBarButton: UIView {
    var delegate: DetailToolBarButtonProtocol?
    
    var icon: UIImage = UIImage() {
        willSet {
            imageView.image = newValue.withAlignmentRectInsets(UIEdgeInsets(top: -12, left: 0, bottom: -12, right: 0))
        }
    }
    var selected: Bool = false {
        willSet {
            if newValue {
                imageView.tintColor = .pointBlue
            }
        }
    }
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = UIColor.init(hex: 0xdcdee8)
        return imageView
    }()
    let button: UIButton = {
        let button = UIButton()
        return button
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imageView)
        addSubview(button)
        
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        button.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        button.addTarget(delegate, action: #selector(didTapButton(_:)), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func didTapButton(_ sender: UIButton) {
        delegate?.didTapToolBarButton(sender)
    }
}
