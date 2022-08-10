//
//  CommonPickViewController.swift
//  TapPlace
//
//  Created by 박상현 on 2022/08/11.
//

import UIKit

class CommonPickViewController: UIViewController {
    /// true / false 순서
    let colorBorder: [UIColor] = [.disabledBorderColor, .activateBorderColor]
    let widthBorder: [CGFloat] = [1, 1.5]
    let colorBackground: [UIColor] = [.clear, .activateBackgroundColor]
    let colorText: [UIColor] = [.disabledTextColor, .pointBlue]
    let activeCell: [Bool] = [false, true]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
}
