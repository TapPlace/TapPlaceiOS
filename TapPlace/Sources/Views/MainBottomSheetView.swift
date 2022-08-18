//
//  MainBottomSheetView.swift
//  TapPlace
//
//  Created by 박상현 on 2022/08/15.
//

import UIKit


class MainBottomSheetView: UIView {
  
    let barView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.init(hex: 0xDBDEE8)
        view.isUserInteractionEnabled = false
        return view
    }()
    let swipeView: UIView = {
        let swipeView = UIView()
        swipeView.backgroundColor = .orange.withAlphaComponent(0.5)
        return swipeView
    }()
    let containerView: UIView = {
        let containerView = UIView()
        containerView.backgroundColor = .pointBlue
        return containerView
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init() has not been implemented")
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .white
        
        barView.layer.cornerRadius = 2
        
        swipeView.isUserInteractionEnabled = true
    
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(draggingView))
        swipeView.addGestureRecognizer(gesture)
        
        
        
        
        
        let locationView: UIView = {
            let locationView = UIView()
            return locationView
        }()
        let locationLabel: UILabel = {
            let locationLabel = UILabel()
            locationLabel.text = "강서구 등촌3동 주변"
            locationLabel.sizeToFit()
            locationLabel.textColor = .black
            locationLabel.font = .systemFont(ofSize: CommonUtils.resizeFontSize(size: 15), weight: .semibold)
            return locationLabel
        }()
        let distanceLabel: UILabel = {
            let distanceLabel = UILabel()
            distanceLabel.text = "1km"
            distanceLabel.sizeToFit()
            distanceLabel.textColor = .black
            distanceLabel.font = locationLabel.font
            return distanceLabel
        }()
        let locationArrowImage: UIImageView = {
            let locationArrowImage = UIImageView()
            locationArrowImage.image = UIImage(systemName: "chevron.down")
            locationArrowImage.tintColor = .black
            locationArrowImage.contentMode = .scaleAspectFit
            return locationArrowImage
        }()
        let locationButton: UIButton = {
            let locationButton = UIButton()
            return locationButton
        }()
        locationButton.addTarget(self, action: #selector(didTapLocation), for: .touchUpInside)
        
        
        addSubview(swipeView)
        swipeView.addSubview(barView)
        
        addSubview(containerView)
        containerView.addSubview(locationView)
        locationView.addSubview(locationLabel)
        locationView.addSubview(distanceLabel)
        locationView.addSubview(locationArrowImage)
        locationView.addSubview(locationButton)
        
        swipeView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(25)
        }
        barView.snp.makeConstraints {
            $0.center.equalTo(swipeView)
            $0.width.equalTo(40)
            $0.height.equalTo(4)
        }
        
        containerView.snp.makeConstraints {
            $0.top.equalTo(swipeView.snp.bottom).offset(10)
            $0.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        locationView.snp.makeConstraints {
            $0.top.bottom.leading.equalTo(locationLabel)
            $0.trailing.equalTo(locationArrowImage)
        }
        locationLabel.snp.makeConstraints {
            $0.top.leading.equalTo(containerView)
        }
        distanceLabel.snp.makeConstraints {
            $0.centerY.equalTo(locationLabel)
            $0.height.equalTo(locationLabel)
            $0.leading.equalTo(locationLabel.snp.trailing).offset(5)
        }
        locationArrowImage.snp.makeConstraints {
            $0.centerY.equalTo(distanceLabel)
            $0.leading.equalTo(distanceLabel.snp.trailing).offset(5)
            $0.height.equalTo(distanceLabel)
        }
        locationButton.snp.makeConstraints {
            $0.edges.equalTo(locationView)
        }
        
    }
        
    @objc func draggingView(_ sender: UIPanGestureRecognizer) {
        let point = sender.location(in: self)
        let draggedView = sender.view!
        draggedView.center.y = point.y
    }
    
    @objc func didTapLocation() {
        print("로케이션 버튼 클릭")
    }
}
