//
//  EditButton.swift
//  TapPlace
//
//  Created by 이상준 on 2022/08/20.
//

import Foundation
import UIKit

protocol EditButtonProtocol {
    func didTapButton(_ sender: EditButton)
}

class EditButton: UIButton {
    
    var delegate: EditButtonProtocol?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension EditButton {
    func choose(_ sender: EditButton) {
        delegate?.didTapButton(sender)
    }
}
