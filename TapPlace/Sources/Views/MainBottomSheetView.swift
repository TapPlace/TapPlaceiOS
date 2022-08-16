//
//  MainBottomSheetView.swift
//  TapPlace
//
//  Created by 박상현 on 2022/08/15.
//

import UIKit


class MainBottomSheetView: PassThroughView {
    
    // MARK: Constants
    enum Mode {
        case tip
        case full
    }
    private enum Const {
        static let duration = 0.5
        static let cornerRadius = 12.0
        static let barViewTopSpacing = 10.0
        static let barViewSize = CGSize(width: UIScreen.main.bounds.width * 0.1, height: 5.0)
        static let bottomSheetRatio: (Mode) -> Double = { mode in
            switch mode {
            case .tip:
                return 1 // 위에서 부터의 값 (밑으로 갈수록 값이 커짐)
            case .full:
                return 0.2
            }
        }
        static let bottomSheetYPosition: (Mode) -> Double = { mode in
            Self.bottomSheetRatio(mode) * UIScreen.main.bounds.height
        }
    }
    
    // MARK: UI
    let bottomSheetView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    private let barView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.init(hex: 0xDBDEE8)
        view.isUserInteractionEnabled = false
        return view
    }()
    
    // MARK: Properties
    var mode: Mode = .tip {
        didSet {
            switch self.mode {
            case .tip:
                break
            case .full:
                break
            }
            self.updateConstraint(offset: Const.bottomSheetYPosition(self.mode))
        }
    }
    var bottomSheetColor: UIColor? {
        didSet { self.bottomSheetView.backgroundColor = self.bottomSheetColor }
    }
    var barViewColor: UIColor? {
        didSet { self.barView.backgroundColor = self.barViewColor }
    }
    
    // MARK: Initializer
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init() has not been implemented")
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .clear
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(didPan))
        self.addGestureRecognizer(panGesture)
        
        self.bottomSheetView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        self.bottomSheetView.layer.cornerRadius = Const.cornerRadius
        self.bottomSheetView.clipsToBounds = true
        
        self.addSubview(self.bottomSheetView)
        self.bottomSheetView.addSubview(self.barView)
        
        self.barView.layer.cornerRadius = 3
        
        self.bottomSheetView.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.top.equalTo(Const.bottomSheetYPosition(.tip))
        }
        self.barView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(Const.barViewTopSpacing)
            $0.size.equalTo(Const.barViewSize)
        }
    }
    
    // MARK: Methods
    @objc private func didPan(_ recognizer: UIPanGestureRecognizer) {
        let translationY = recognizer.translation(in: self).y
        let minY = self.bottomSheetView.frame.minY
        let offset = translationY + minY
        
        if Const.bottomSheetYPosition(.full)...Const.bottomSheetYPosition(.tip) ~= offset {
            self.updateConstraint(offset: offset)
            recognizer.setTranslation(.zero, in: self)
        }
        UIView.animate(
            withDuration: 0,
            delay: 0,
            options: .curveEaseOut,
            animations: self.layoutIfNeeded,
            completion: nil
        )
        
        guard recognizer.state == .ended else { return }
        UIView.animate(
            withDuration: Const.duration,
            delay: 0,
            options: .allowUserInteraction,
            animations: {
                // velocity를 이용하여 위로 스와이프인지, 아래로 스와이프인지 확인
                self.mode = recognizer.velocity(in: self).y >= 0 ? Mode.tip : .full
            },
            completion: nil
        )
    }
    
    public func updateConstraint(offset: Double) {
        UIView.animate(withDuration: 0.3, delay: 0, animations: {
            self.bottomSheetView.snp.remakeConstraints {
                $0.left.right.bottom.equalToSuperview()
                $0.top.equalToSuperview().inset(offset)
            }
            self.superview?.layoutIfNeeded()
        })
    }
}
