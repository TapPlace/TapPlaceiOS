//
//  SearchButton.swift
//  TapPlace
//
//  Created by 이상준 on 2022/08/17.
//

import UIKit

protocol SearchButtonProtocol{
    func didTapButton()
}

class SearchButton: UIButton {
    var isActive: Bool = false
    var delegate: SearchButtonProtocol?
  
}

extension SearchButton {
    @objc func tapButton() {
        delegate?.didTapButton()
    }
}
