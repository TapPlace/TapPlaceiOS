//
//  AroundPlaceFilterView.swift
//  TapPlace
//
//  Created by 박상현 on 2022/08/19.
//

import UIKit
import AlignedCollectionViewFlowLayout

protocol AroundFilterViewProtocol {
    func showFilterView(show: Bool)
}

class AroundPlaceFilterView: UIView {
    static var viewDelegate: AroundFilterViewProtocol?
    
    let filterContainerView: UIView = {
        let filterContainerView = UIView()
        filterContainerView.backgroundColor = .white
        return filterContainerView
    }()
    
    let wrapView: UIView = {
        let wrapView = UIView()
        wrapView.backgroundColor = .pointBlue
        return wrapView
    }()

    
    let bottomButton = BottomButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func didTapCloseButton() {
        AroundPlaceFilterView.viewDelegate?.showFilterView(show: false)
    }
}

extension AroundPlaceFilterView: BottomButtonProtocol {
    func didTapBottomButton() {
        if bottomButton.isActive {
            print("필터 적용 실행")
        } else {
            print("필터 적용 실행 실패")
        }
    }
    
    /**
     * @ 초기 레이아웃 설정
     * coder : sanghyeon
     */
    func setupView() {
        //MARK: ViewDefine
        let titleView: UIView = {
            let titleView = UIView()
            return titleView
        }()
        let titleLabel: UILabel = {
            let titleLabel = UILabel()
            titleLabel.text = "필터"
            titleLabel.textColor = .black
            titleLabel.font = .systemFont(ofSize: CommonUtils.resizeFontSize(size: 16), weight: .regular)
            titleLabel.sizeToFit()
            return titleLabel
        }()
        let closeButton: UIButton = {
            let closeButton = UIButton()
            closeButton.setImage(UIImage(systemName: "xmark"), for: .normal)
            closeButton.tintColor = .black
            return closeButton
        }()
        
        //MARK: ViewPropertyManual
        bottomButton.backgroundColor = .deactiveGray
        bottomButton.setTitle("적용", for: .normal)
        bottomButton.setTitleColor(UIColor.init(hex: 0xAFB4C3), for: .normal)
        
        //MARK: AddSubView
        addSubview(filterContainerView)
        filterContainerView.addSubview(titleView)
        titleView.addSubview(titleLabel)
        titleView.addSubview(closeButton)
        filterContainerView.addSubview(wrapView)
        
        filterContainerView.addSubview(bottomButton)
        
        //MARK: ViewContraints
        filterContainerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        titleView.snp.makeConstraints {
            $0.height.equalTo(50)
            $0.top.leading.trailing.equalTo(filterContainerView)
        }
        titleLabel.snp.makeConstraints {
            $0.center.equalTo(titleView)
        }
        closeButton.snp.makeConstraints {
            $0.trailing.equalTo(filterContainerView)
            $0.width.height.equalTo(titleView.snp.height)
        }
        wrapView.snp.makeConstraints {
            $0.top.equalTo(titleView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(bottomButton.snp.top)
        }
        bottomButton.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.top.equalTo(safeAreaLayoutGuide.snp.bottom).offset(-60)
        }
        
        //MARK: ViewAddTarget
        closeButton.addTarget(self, action: #selector(didTapCloseButton), for: .touchUpInside)
        
        
        //MARK: Delegate
        bottomButton.delegate = self
        
    }
}
