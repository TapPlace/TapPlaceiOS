//
//  MoreListFilterTitle.swift
//  TapPlace
//
//  Created by 박상현 on 2022/09/07.
//

import UIKit

protocol FilterTitleProtocol {
    func didTapFilterSortButton()
    func didTapFilterEditButton()
}

class MoreListFilterTitle: UIView {
    var delegate: FilterTitleProtocol?
    
    let containerView = UIView()
    var filterButton = UIButton()
    var editButton = UIButton()
    var storeTitleLabel = UILabel()
    var filterCountLabel = UILabel()
    
    var filterName: String = "" {
        willSet {
            storeTitleLabel.text = newValue
        }
    }
    
    var filterCount: Int = 0 {
        willSet {
            filterCountLabel.text = "\(newValue)"
        }
    }
    
    var filterButtonSetImage: String = "chevron.down" {
        willSet {
            filterButton.setImage(UIImage(systemName: newValue), for: .normal)
        }
    }
    
    var setFilterName: String = "" {
        willSet {
            filterButton.setTitle(newValue, for: .normal)
        }
    }
    
    var isUseEditMode: Bool = true {
        willSet {
            if !newValue {
                editButton.isHidden = true
                filterButton.snp.remakeConstraints {
                    $0.trailing.equalTo(containerView).offset(-20)
                    $0.centerY.equalToSuperview()
                }
            }
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension MoreListFilterTitle {
    /**
     * @ 초기 레이아웃 설정
     * coder : sanghyeon
     */
    func setupView() {
        //MARK: ViewDefine
        storeTitleLabel = {
            let storeTitleLabel = UILabel()
            storeTitleLabel.sizeToFit()
            storeTitleLabel.text = "가맹점"
            storeTitleLabel.textColor = .init(hex: 0x333333)
            storeTitleLabel.font = .systemFont(ofSize: CommonUtils.resizeFontSize(size: 14), weight: .regular)
            return storeTitleLabel
        }()
        filterCountLabel = {
            let filterCountLabel = UILabel()
            filterCountLabel.sizeToFit()
            filterCountLabel.text = "5"
            filterCountLabel.textColor = .pointBlue
            filterCountLabel.font = .systemFont(ofSize: CommonUtils.resizeFontSize(size: 14), weight: .bold)
            return filterCountLabel
        }()
        filterButton = {
            let filterButton = UIButton(type: .system)
            filterButton.semanticContentAttribute = .forceRightToLeft
            filterButton.imageEdgeInsets = UIEdgeInsets(top: .zero, left: 5, bottom: .zero, right: .zero)
            filterButton.setTitle("등록순", for: .normal)
            filterButton.setImage(UIImage(systemName: "chevron.down"), for: .normal)
            filterButton.setPreferredSymbolConfiguration(.init(pointSize: CommonUtils.resizeFontSize(size: 14), weight: .regular, scale: .default), forImageIn: .normal)
            filterButton.tintColor = .init(hex: 0x333333)
            filterButton.titleLabel?.font = .systemFont(ofSize: CommonUtils.resizeFontSize(size: 14))
            return filterButton
        }()
        let bottomLine: UIView = {
            let bottomLine = UIView()
            bottomLine.backgroundColor = .init(hex: 0xDBDEE8, alpha: 0.4)
            return bottomLine
        }()
        
        
        editButton = {
            let editButton = UIButton(type: .system)
            editButton.setTitle("편집", for: .normal)
            editButton.tintColor = .init(hex: 0x333333)
            editButton.titleLabel?.font = .systemFont(ofSize: CommonUtils.resizeFontSize(size: 14), weight: .regular)
            return editButton
        }()
        
        
        
        //MARK: ViewPropertyManual
        
        
        //MARK: AddSubView
        self.addSubview(containerView)
        containerView.addSubview(storeTitleLabel)
        containerView.addSubview(filterCountLabel)
        containerView.addSubview(filterButton)
        containerView.addSubview(bottomLine)
        
        containerView.addSubview(editButton)
        
        
        //MARK: ViewContraints
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        storeTitleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
        filterCountLabel.snp.makeConstraints {
            $0.leading.equalTo(storeTitleLabel.snp.trailing).offset(3)
            $0.centerY.equalTo(storeTitleLabel)
        }
        filterButton.snp.makeConstraints {
            $0.trailing.equalTo(editButton.snp.leading).offset(-20)
            $0.centerY.equalToSuperview()
        }
        bottomLine.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        
        editButton.snp.makeConstraints {
            $0.trailing.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
        
        
        //MARK: ViewAddTarget
        filterButton.addTarget(self, action: #selector(didTapFilterButton), for: .touchUpInside)
        editButton.addTarget(self, action: #selector(didTapEditButton), for: .touchUpInside)
        
        //MARK: Delegate
    }
    
    /**
     * @ 필터 버튼 클릭 함수
     * coder : sanghyeon
     */
    @objc func didTapFilterButton(){
        delegate?.didTapFilterSortButton()
    }
    /**
     * @ 편집 버튼 클릭 함수
     * coder : sanghyeon
     */
    @objc func didTapEditButton() {
        delegate?.didTapFilterEditButton()
    }
}


#if DEBUG
import SwiftUI

@available(iOS 13.0, *)
struct MoreListFilterTitle_Preview: PreviewProvider {
    static var previews: some View {
                // 이런식으로 사용합니다‼️
        UIViewPreview {
            let view = MoreListFilterTitle()
            return view

        }
        .previewLayout(.sizeThatFits)
        .padding(10)
    }
}
#endif
