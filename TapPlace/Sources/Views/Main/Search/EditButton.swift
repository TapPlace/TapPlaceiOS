//
//  EditButton.swift
//  TapPlace
//
//  Created by 이상준 on 2022/08/20.
//

import Foundation
import UIKit

protocol ChooseBtnProtocol {
    func choose(_ sender: EditButton)
}

protocol DeleteBtnProtocol {
    func delete(_ sender: EditButton)
}

class EditButton: UIButton {
    
    var chooseDelegate: ChooseBtnProtocol?
    var deleteDelegate: DeleteBtnProtocol?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension EditButton {
    func choose(_ sender: EditButton) {
        chooseDelegate?.choose(sender)
    }
}

extension EditButton {
    func delete(_ sender: EditButton) {
        deleteDelegate?.delete(sender)
    }
}
