//
//  ToastMessage.swift
//  TapPlace
//
//  Created by 박상현 on 2022/08/26.
//

import Foundation
import UIKit

public func showToast(message: String, duration: Double = 2.0, font: UIFont = .systemFont(ofSize: 14), view: UIView) {
    let toastView: UIView = {
        let toastView = UIView()
        toastView.backgroundColor = .pointBlue
        toastView.alpha = 1.0
        return toastView
    }()
    
    let toastLabel: UILabel = {
        let toastLabel = UILabel()
        toastLabel.text = message
        toastLabel.textColor = .white
        toastLabel.sizeToFit()
        toastLabel.numberOfLines = 0
        toastLabel.font = font
        return toastLabel
    }()
    
    view.addSubview(toastView)
    toastView.addSubview(toastLabel)
    toastView.snp.makeConstraints {
        $0.top.leading.trailing.equalToSuperview()
        $0.bottom.equalTo(toastLabel).offset(15)
    }
    toastLabel.snp.makeConstraints {
        $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
        $0.top.equalTo(view.safeAreaLayoutGuide).offset(15)
    }
    UIView.animate(withDuration: 2.0, delay: duration, options: .curveEaseOut, animations: {
        toastView.alpha = 0
    }, completion: {(isCompleted) in
        toastView.removeFromSuperview()
    })
}
