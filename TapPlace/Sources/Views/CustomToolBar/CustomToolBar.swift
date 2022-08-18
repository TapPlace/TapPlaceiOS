//
//  CustomToolBar.swift
//  TapPlace
//
//  Created by 박상현 on 2022/08/16.
//

import UIKit

class CustomToolBar: UIView {
    
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
        
        compassButton.icon = UIImage(systemName: "safari.fill")!
        bookmarkButton.icon = UIImage(systemName: "bookmark.fill")!
        shareButton.icon = UIImage(systemName: "square.and.arrow.up.fill")!
        
        
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
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}


/**
 
 
 
 
 
 
 override init(frame: CGRect) {
 super.init(frame: frame)
 backgroundColor = .white
 
 compassButton.icon = UIImage(systemName: "safari.fill")!
 bookmarkButton.icon = UIImage(systemName: "bookmark.fill")!
 shareButton.icon = UIImage(systemName: "square.and.arrow.up.fill")!
 
 
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
 }
 
 required init?(coder: NSCoder) {
 fatalError("init(coder:) has not been implemented")
 }
 
 
 */
