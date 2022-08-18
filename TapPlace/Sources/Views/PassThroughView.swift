//
//  PassThroughView.swift
//  TapPlace
//
//  Created by 박상현 on 2022/08/16.
//

import UIKit

class PassThroughView: UIView {
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let hitView = super.hitTest(point, with: event)
        // superview가 터치 이벤트를 받을 수 있도록,
        // 해당 뷰 (subview)가 터치되면 nil을 반환하고 다른 뷰일경우 UIView를 반환
        
        let grabber = self as! MainBottomSheetView
        if hitView == grabber.swipeView {
            print("###### 그래버 터치됨 ######")
            return hitView
        }
        
        dump(grabber.containerView.frame)
        return nil
    }
}
