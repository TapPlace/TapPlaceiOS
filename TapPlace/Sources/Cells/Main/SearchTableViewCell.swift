//
//  SearchingTableViewCell.swift
//  TapPlace
//
//  Created by 이상준 on 2022/08/15.
//

import UIKit

// X버튼에 대한 프로토콜
protocol XBtnProtocol {
    func deleteCell(index: Int) // 셀 삭제
}

// 검색 테이블 뷰 셀
class SearchTableViewCell: UITableViewCell {
    
    static let identifier = "SearchRecordCell"
    var delegate:XBtnProtocol?
    var index: IndexPath?
    
    // 테이블 뷰 안 이미지 뷰
    let img: UIImageView = {
        let imgView = UIImageView()
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
        deleteButton.addTarget(self, action: #selector(deleteCell(_:)), for: .touchUpInside)
        return deleteButton
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addContentView()
        autoLayout()
    }
    
    // content view에 추가
    private func addContentView() {
        contentView.addSubview(img)
        contentView.addSubview(label)
        contentView.addSubview(deleteButton)
    }
    
    private func autoLayout() {
        
        img.snp.makeConstraints {
            $0.width.equalTo(20)
            $0.height.equalTo(20)
            $0.top.equalTo(contentView.safeAreaLayoutGuide).offset(16)
            $0.leading.equalTo(contentView.safeAreaLayoutGuide).offset(20)
            $0.bottom.equalTo(contentView.safeAreaLayoutGuide).offset(-18)
        }
        
        label.snp.makeConstraints {
            $0.top.equalTo(contentView.safeAreaLayoutGuide).offset(16)
            $0.leading.equalTo(img.snp_trailingMargin).offset(10)
            $0.bottom.equalTo(contentView.safeAreaLayoutGuide).offset(-18)
        }
        
        deleteButton.snp.makeConstraints {
            $0.top.equalTo(contentView.safeAreaLayoutGuide).offset(16)
            $0.trailing.equalTo(contentView.safeAreaLayoutGuide).offset(-20)
            $0.width.height.equalTo(20)
        }
    }
    
    @objc func deleteCell(_ sender: UIButton) {
        delegate?.deleteCell(index: (index?.row)!)
        print("\(index) 버튼 눌림")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
