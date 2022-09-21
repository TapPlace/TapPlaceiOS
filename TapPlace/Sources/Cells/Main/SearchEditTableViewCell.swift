//
//  SearchEditTableViewCell.swift
//  TapPlace
//
//  Created by 이상준 on 2022/08/20.
//
import UIKit

class SearchEditTableViewCell: UITableViewCell {
    static let identifier = "SearchEditCell"
    var index: IndexPath?
    var storeID: String?
    
    // 셀 선택 여부
    var cellSeclected: Bool = false {
        willSet {
            checkImage.image = newValue ? UIImage(named: "checkCircleFill") : UIImage(named: "checkCircle")
        }
    }
    
    let checkImage: UIImageView = {
        let checkImage = UIImageView()
        checkImage.image = UIImage(named: "checkCircle")
        checkImage.contentMode = .scaleAspectFit
        return checkImage
    }()
    
    // 테이블 뷰 안 이미지 뷰
    let img: UIImageView = {
        let imgView = UIImageView()
        return imgView
    }()
    
    // 테이블 뷰 안 라벨
    let label: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = UIColor(red: 0.302, green: 0.302, blue: 0.302, alpha: 1)
        label.font = .systemFont(ofSize: CommonUtils.resizeFontSize(size: 15), weight: .medium)
        label.sizeToFit()
        return label
    }()
    
    // 테이블 뷰 셀 하단 선
    let bottomLine: UIView = {
        let bottomLine = UIView()
        bottomLine.backgroundColor = .init(hex: 0xDBDEE8, alpha: 0.4)
        return bottomLine
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addContentView()
        setLayout()
    }
    
    // content view에 추가
    private func addContentView() {
        contentView.addSubview(checkImage)
        contentView.addSubview(img)
        contentView.addSubview(label)
        contentView.addSubview(bottomLine)
    }
    
    private func setLayout() {
        
        let safeArea = contentView.safeAreaLayoutGuide
        
        checkImage.snp.makeConstraints {
            $0.centerY.equalTo(contentView)
            $0.leading.equalTo(safeArea).offset(21)
            $0.width.height.equalTo(16)
        }
        
        img.snp.makeConstraints {
            $0.leading.equalTo(checkImage.snp.trailing).offset(15)
            $0.centerY.equalTo(contentView)
            $0.width.height.equalTo(15)
        }
        
        label.snp.makeConstraints {
            $0.leading.equalTo(img.snp.trailing).offset(11)
            $0.centerY.equalTo(contentView)
        }
        
        bottomLine.snp.makeConstraints {
            $0.bottom.equalTo(contentView)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(1)
        }
    }
    

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        checkImage.image = UIImage(named: "checkCircle")
    }
}
