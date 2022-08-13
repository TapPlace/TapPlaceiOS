//
//  CustomTabBar.swift
//  TapPlace
//
//  Created by 박상현 on 2022/08/13.
//

import UIKit

class CustomTabBar: UITabBar {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
//        let floatingButton = TabBarViewController().floatingButton
//        let from = point
//        let to = floatingButton.center
//        return sqrt((from.x - to.x) * (from.x - to.x) + (from.y - to.y) * (from.y - to.y)) <= 35 ? floatingButton : super.hitTest(point, with: event)
//    }
}
