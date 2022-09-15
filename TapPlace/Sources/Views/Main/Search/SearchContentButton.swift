//
//  SearchButton.swift
//  TapPlace
//
//  Created by 이상준 on 2022/08/17.
//

import UIKit

protocol SearchContentButtonProtocol{
    func didTapButton(_ sender: SearchContentButton)
}

class SearchContentButton: UIButton {
    var isActive: Bool = false
    var delegate: SearchContentButtonProtocol?
  
    override init(frame: CGRect) {
        super.init(frame: frame)
        addTarget(self, action: #selector(tapButton(_:)), for: .touchUpInside) 
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SearchContentButton {
    @objc func tapButton(_ sender: SearchContentButton) {
        delegate?.didTapButton(sender)
//        print("\(sender.tag) 클릭됨")
    }
}
