//
//  AroundStoreTableViewCell.swift
//  TapPlace
//
//  Created by 박상현 on 2022/08/17.
//

import UIKit
 
class AroundStoreTableViewCell: UITableViewCell {

    static let cellId = "aroundStoreItem"
    var bookmarkViewModel = BookmarkViewModel()
    
    var cellIndex: Int = 0 {
        willSet {
            storeInfoView.thisIndex = newValue
        }
    }
    
    var storeInfo: StoreInfo = StoreInfo.emptyStoreInfo {
        willSet {
            storeInfoView.storeInfo = newValue
        }
    }
    
    var isBookmark: Bool = false {
        willSet {
            if newValue {
                bookmarkButton.tintColor = .pointBlue
            } else {
                bookmarkButton.tintColor = .init(hex: 0xDBDEE8)
            }
        }
    }

    let storeInfoView = StoreInfoView()
    var bookmarkButton = UIButton()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super .init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        /// 재사용하면서 생기는 문제로 인해 셀 초기화
        storeInfoView.brandStackView.removeAllArrangedSubviews()
    }
}

extension AroundStoreTableViewCell {
    func setupCell() {
        bookmarkButton = {
            let bookmarkButton = UIButton()
            bookmarkButton.setImage(UIImage(named: "bookmark")?.withRenderingMode(.alwaysTemplate), for: .normal)
            bookmarkButton.tintColor = .init(hex: 0xDBDEE8)
            bookmarkButton.contentEdgeInsets = UIEdgeInsets(top: 20, left: 10, bottom: 20, right: 10)
            return bookmarkButton
        }()
        
        addSubview(storeInfoView)
        addSubview(bookmarkButton)
        
        storeInfoView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        bookmarkButton.snp.makeConstraints {
            $0.trailing.centerY.equalToSuperview()
        }
        
        bookmarkButton.addTarget(self, action: #selector(didTapBookmarkButton), for: .touchUpInside)
    }
    /**
     * @ 즐겨찾기 버튼 클릭 함수
     * coder : sanghyeon
     */
    @objc func didTapBookmarkButton() {
        //self.isBookmark = storageViewModel.toggleBookmark(storeInfo.convertBookmark())
        var setBookmark: Bool = isBookmark
        setBookmark.toggle()
        bookmarkViewModel.requestToggleBookmark(isBookmark: setBookmark, storeID: storeInfo.storeID) { result in
            if let result = result {
                if result {
                    self.isBookmark = setBookmark
                    if let index = AroundStoreModel.list?.firstIndex(where: {$0.storeID == self.storeInfo.storeID}) {
                        AroundStoreModel.list?[index].isBookmark = setBookmark
                    }
                }
            }
        }
    }
    
}
