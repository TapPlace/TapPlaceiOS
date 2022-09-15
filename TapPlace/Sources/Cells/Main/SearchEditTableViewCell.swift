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
    let checkButtonColor: [UIColor] = [.init(hex: 0xCDD2DF), .pointBlue]
    var storeID: String?
    
    // 셀 선택 여부
    var cellSeclected: Bool = false {
        willSet {
            let arrRow = newValue ? 1 : 0
            checkImage.tintColor = checkButtonColor[arrRow]
        }
    }
    
    let checkImage: UIImageView = {
        let checkImage = UIImageView()
        checkImage.image = UIImage(named: "checkmark")?.withRenderingMode(.alwaysTemplate)
        checkImage.tintColor = .init(hex: 0xCDD2DF)
        checkImage.contentMode = .scaleAspectFit
        return checkImage
    }()
    
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
        label.textColor = UIColor(red: 0.302, green: 0.302, blue: 0.302, alpha: 1)
        label.font = UIFont(name: "AppleSDGothicNeoM00-Regular", size: 15)
        label.sizeToFit()
        return label
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
    }
    
    private func setLayout() {
        
        let safeArea = contentView.safeAreaLayoutGuide
        
        checkImage.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(safeArea).offset(21)
            $0.width.height.equalTo(14)
        }
        
        img.snp.makeConstraints {
            $0.leading.equalTo(checkImage.snp.trailing).offset(15)
            $0.centerY.equalToSuperview()
        }
        
        label.snp.makeConstraints {
            $0.leading.equalTo(img.snp.trailing).offset(11)
            $0.centerY.equalToSuperview()
        }
    }
    

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        checkImage.tintColor = checkButtonColor[0]
    }
}
