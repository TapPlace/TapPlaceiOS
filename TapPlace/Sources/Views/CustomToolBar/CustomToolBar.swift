//
//  CustomToolBar.swift
//  TapPlace
//
//  Created by 박상현 on 2022/08/16.
//

import UIKit

protocol CustomToolBarProtocol {
    var storeInfo: StoreInfo? { get set }
}

protocol CustomToolBarShareProtocol {
    func showShare(storeID: String)
}

class CustomToolBar: UIView, DetailToolBarButtonProtocol {
    var storageViewModel = StorageViewModel()
    var viewController = UIViewController()
    var isBookmark: Bool = false
    
    func didTapToolBarButton(_ sender: UIButton) {
        guard let delegate = delegate else { return }
        guard let storeInfo = delegate.storeInfo else { return }
        switch sender {
        case compassButton.button:
            let url = URL(string: "nmap://map?lat=\(storeInfo.y)&lng=\(storeInfo.x)&zoom=20&appname=kr.co.tapplace.TapPlace")!
            let appStoreURL = URL(string: "http://itunes.apple.com/app/id311867728?mt=8")!

            if UIApplication.shared.canOpenURL(url) {
              UIApplication.shared.open(url)
            } else {
              UIApplication.shared.open(appStoreURL)
            }
        case bookmarkButton.button:
            let result = storageViewModel.toggleBookmark(storeInfo.convertBookmark())
            bookmarkButton.selected = result
        case shareButton.button:
            let shareUrl = "\(Constants.tapplaceBaseUrl)/app/\(storeInfo.storeID)"
            vcDelegate?.showShare(storeID: storeInfo.storeID)
        default:
            break
        }
    }
    
    
    var delegate: CustomToolBarProtocol?
    var vcDelegate: CustomToolBarShareProtocol?
    
    let toolBar: UIView = {
        let toolBar = UIView()
        toolBar.backgroundColor = .white
        return toolBar
    }()
    let toolBarLine: UIView = {
        let toolBarLine = UIView()
        toolBarLine.backgroundColor = UIColor.init(hex: 0xDBDEE8, alpha: 0.4)
        return toolBarLine
    }()
    let toolBarStackView: UIStackView = {
        let toolBarStackView = UIStackView()
        toolBarStackView.axis = .horizontal
        toolBarStackView.alignment = .fill
        toolBarStackView.distribution = .fillEqually
        return toolBarStackView
    }()
    
    let compassButton = DetailToolBarButton()
    let bookmarkButton = DetailToolBarButton()
    let shareButton = DetailToolBarButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        
        compassButton.icon = UIImage(named: "map")!
        bookmarkButton.icon = UIImage(named: "bookmark")!
        shareButton.icon = UIImage(named: "share")!
        
        compassButton.delegate = self
        bookmarkButton.delegate = self
        shareButton.delegate = self
        
        
        compassButton.selected = true
        
        addSubview(toolBar)
        toolBar.addSubview(toolBarLine)
        toolBar.addSubview(toolBarStackView)
        toolBarStackView.addArrangedSubview(compassButton)
        toolBarStackView.addArrangedSubview(bookmarkButton)
        toolBarStackView.addArrangedSubview(shareButton)
        
        toolBar.snp.makeConstraints {
            $0.leading.trailing.bottom.equalTo(safeAreaLayoutGuide)
            $0.height.equalTo(48)
        }
        toolBarLine.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(toolBar)
            $0.height.equalTo(1)
        }
        toolBarStackView.snp.makeConstraints {
            $0.edges.equalTo(toolBar)
        }
        
        
        
        DispatchQueue.main.async {
            if let storeID = self.delegate?.storeInfo?.storeID {
                self.bookmarkButton.selected = self.storageViewModel.isStoreBookmark(storeID)
            }
        }
        
        // 베타 버전 임시 숨김
        shareButton.isHidden = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}


