//
//  FeedbackListCell.swift
//  TapPlace
//
//  Created by 박상현 on 2022/09/08.
//

import UIKit
import CoreLocation

class FeedbackListCell: UITableViewCell {

    static let cellId = "feedbackListItem"
    var feedback: UserFeedbackStoreModel? = nil {
        willSet {
            guard let feedback = newValue else { return }
            dateLabel.text = feedback.date
            storeNameLabel.text = feedback.storeName
            storeCategory.text = feedback.storeCategory
            
            var placeDistance: Double?
            if let _ = UserInfo.userLocation {
                let storeLocation = CLLocationCoordinate2D(latitude: feedback.locationY ?? 0, longitude: feedback.locationX ?? 0)
                placeDistance = UserInfo.userLocation?.distance(from: storeLocation)
            } else {
                placeDistance = 0
            }
            
            setAttributedString(distance: DistancelModel.getDistance(distance: placeDistance!), address: feedback.address)
        }
    }
    
    var isBottomLineHidden: Bool = false {
        willSet {
            if newValue {
                bottomLine.isHidden = true
            } else {
                bottomLine.isHidden = false
            }
        }
    }
    
    var dateLabel = UILabel()
    var storeNameLabel = UILabel()
    var storeCategory = UILabel()
    var detailLabel = UILabel()
    var bottomLine = UIView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super .init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
extension FeedbackListCell {
    func setupCell() {
        let containerView = UIView()
        dateLabel = {
            let dateLabel = UILabel()
            dateLabel.sizeToFit()
            dateLabel.font = .systemFont(ofSize: CommonUtils.resizeFontSize(size: 12), weight: .medium)
            dateLabel.textColor = .init(hex: 0x9E9E9E)
            return dateLabel
        }()
        storeNameLabel = {
            let storeNameLabel = UILabel()
            storeNameLabel.sizeToFit()
            storeNameLabel.font = .systemFont(ofSize: CommonUtils.resizeFontSize(size: 16), weight: .medium)
            storeNameLabel.textColor = .init(hex: 0x333333)
            return storeNameLabel
        }()
        storeCategory = {
            let storeCategory = UILabel()
            storeCategory.sizeToFit()
            storeCategory.font = .systemFont(ofSize: CommonUtils.resizeFontSize(size: 13), weight: .medium)
            storeCategory.textColor = .init(hex: 0x9E9E9E)
            return storeCategory
        }()
        detailLabel = {
            let detailLabel = UILabel()
            detailLabel.sizeToFit()
            detailLabel.font = .systemFont(ofSize: CommonUtils.resizeFontSize(size: 12), weight: .medium)
            detailLabel.textColor = .init(hex: 0x707070)
            return detailLabel
        }()
        let arrowIcon: UIImageView = {
            let arrowIcon = UIImageView()
            arrowIcon.contentMode = .scaleAspectFit
            arrowIcon.image = UIImage(systemName: "chevron.forward")
            arrowIcon.tintColor = .init(hex: 0x9E9E9E)
            return arrowIcon
        }()
        bottomLine = {
            let bottomLine = UIView()
            bottomLine.backgroundColor = .init(hex: 0xDBDEE8, alpha: 0.4)
            return bottomLine
        }()
        
        self.addSubview(containerView)
        containerView.addSubview(dateLabel)
        containerView.addSubview(storeNameLabel)
        containerView.addSubview(storeCategory)
        containerView.addSubview(detailLabel)
        containerView.addSubview(arrowIcon)
        containerView.addSubview(bottomLine)
        
        containerView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.top.bottom.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
        dateLabel.snp.makeConstraints {
            $0.bottom.equalTo(storeNameLabel.snp.top).offset(-10)
            $0.leading.equalTo(containerView)
        }
        storeNameLabel.snp.makeConstraints {
            $0.leading.centerY.equalTo(containerView)
        }
        storeCategory.snp.makeConstraints {
            $0.leading.equalTo(storeNameLabel.snp.trailing).offset(10)
            $0.bottom.equalTo(storeNameLabel)
        }
        detailLabel.snp.makeConstraints {
            $0.leading.equalTo(containerView)
            $0.top.equalTo(storeNameLabel.snp.bottom).offset(10)
        }
        arrowIcon.snp.makeConstraints {
            $0.trailing.centerY.equalTo(containerView)
            $0.width.height.equalTo(20)
        }
        bottomLine.snp.makeConstraints {
            $0.leading.trailing.bottom.equalTo(containerView)
            $0.height.equalTo(1)
        }
        
    }
    
    func setAttributedString(distance: String, address: String) {
        var storeDetailText = "#DISTANCE \u{2022} #ADDRESS"
        storeDetailText = storeDetailText.replacingOccurrences(of: "#DISTANCE", with: distance)
        storeDetailText = storeDetailText.replacingOccurrences(of: "#ADDRESS", with: address)
        let attributedString = NSMutableAttributedString(string: storeDetailText)
        detailLabel.attributedText = attributedString
    }
}
