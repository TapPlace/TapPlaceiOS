//
//  SearchingTableViewCell.swift
//  TapPlace
//
//  Created by 이상준 on 2022/08/15.
// 

import UIKit

// X버튼에 대한 프로토콜
protocol XBtnProtocol {
    func deleteCell(storeID: String) // 셀 삭제
}

// 검색 테이블 뷰 셀
class SearchHistoryTableViewCell: UITableViewCell {
    
    static let identifier = "SearchRecordCell"
    var delegate:XBtnProtocol?
    var index: IndexPath?
    var storeCategory: String = "" {
        willSet {
            if let store = StoreModel.lists.first(where: {$0.title == newValue}) {
                img.image = StoreModel.lists.first(where: { $0.title == newValue}) == nil ? UIImage(named: "etc") : UIImage(named: store.id)
            } else {
                img.image = UIImage(named: "etc")
            }
        }
    }
   var storeInfo: StoreInfo?
    
    // 테이블 뷰 안 이미지 뷰
    let img: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFit
        imgView.image = UIImage(named: "")
        return imgView
    }()
    
    // 테이블 뷰 안 라벨
    let label: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.7)
        label.font = .systemFont(ofSize: 15)
        label.sizeToFit()
        return label
    }()
    
    // 테이블 뷰 안 X버튼
    let deleteButton: UIButton = {
        let deleteButton = UIButton()
        deleteButton.tintColor = .lightGray
        return deleteButton
    }()
    
    // 테이블 뷰 하단 선
    let bottomLine: UIView = {
        let bottomLine = UIView()
        bottomLine.backgroundColor = .init(hex: 0xDBDEE8, alpha:0.4)
        return bottomLine
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addContentView()
        setLayout()
    }
    
    // content view에 추가
    private func addContentView() {
        contentView.addSubview(img)
        contentView.addSubview(label)
        contentView.addSubview(deleteButton)
        contentView.addSubview(bottomLine)
    }
    
    private func setLayout() {
        
        img.snp.makeConstraints {
            $0.width.equalTo(20)
            $0.height.equalTo(20)
            $0.centerY.equalTo(contentView)
            $0.leading.equalTo(contentView).offset(20)
        }
        
        label.snp.makeConstraints {
            $0.centerY.equalTo(contentView)
            $0.leading.equalTo(img.snp.trailing).offset(10)
        }
        
        deleteButton.snp.makeConstraints {
            $0.centerY.equalTo(contentView)
            $0.trailing.equalTo(contentView).offset(-20)
            $0.width.height.equalTo(20)
        }
        
        bottomLine.snp.makeConstraints {
            $0.bottom.equalTo(contentView)
            $0.leading.trailing.equalTo(contentView).inset(20)
            $0.height.equalTo(1)
        }
        
        deleteButton.addTarget(self, action: #selector(deleteCell(_:)), for: .touchUpInside)
    }
    
    @objc func deleteCell(_ sender: UIButton) {
        guard let storeInfo = storeInfo else { return }
        delegate?.deleteCell(storeID: storeInfo.storeID)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        deleteButton.addTarget(self, action: #selector(deleteCell(_:)), for: .touchUpInside)
    }
}
