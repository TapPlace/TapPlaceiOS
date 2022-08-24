//
//  SearchEditTableViewCell.swift
//  TapPlace
//
//  Created by 이상준 on 2022/08/20.
//
import UIKit

protocol CheckButtonProtocol{
    func check(index: Int)
}

class SearchEditTableViewCell: UITableViewCell {
    static let identifier = "SearchEditCell"
    var delegate: CheckButtonProtocol?
    var index: IndexPath?
    let checkButtonColor: [UIColor] = [.white, .pointBlue]
    
    // 셀 선택 여부
    var cellSeclected: Bool = false {
        willSet {
            let arrRow = newValue ? 1 : 0
            self.checkButton.backgroundColor = self.checkButtonColor[arrRow]
        }
    }
    
    // 테이블 뷰 안 버튼
    let checkButton: UIButton = {
        let checkButton = UIButton()
        checkButton.backgroundColor = .white
        checkButton.layer.cornerRadius = 15
        checkButton.tintColor = UIColor(red: 0.859, green: 0.871, blue: 0.91, alpha: 1)
        checkButton.addTarget(self, action: #selector(choose(_:)), for: .touchUpInside)
        return checkButton
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
        autoLayout()
    }
    
    // content view에 추가
    private func addContentView() {
        contentView.addSubview(checkButton)
        contentView.addSubview(img)
        contentView.addSubview(label)
    }
    
    private func autoLayout() {
        
        let safeArea = contentView.safeAreaLayoutGuide
        
        checkButton.snp.makeConstraints {
            $0.top.equalTo(safeArea).offset(19.67)
            $0.leading.equalTo(safeArea).offset(21)
            $0.bottom.equalTo(safeArea).offset(-17.67)
        }
        
        img.snp.makeConstraints {
            $0.top.equalTo(safeArea).offset(19)
            $0.leading.equalTo(checkButton.snp.trailing).offset(15)
            $0.bottom.equalTo(safeArea).offset(-17)
        }
        
        label.snp.makeConstraints {
            $0.top.equalTo(safeArea).offset(19)
            $0.leading.equalTo(img.snp.trailing).offset(11)
            $0.bottom.equalTo(safeArea).offset(-17)
        }
    }
    
    @objc func choose(_ sender: Any) { 
        delegate?.check(index: (index?.row)!)

//        if checkButton.backgroundColor == .white {
//            checkButton.backgroundColor = UIColor(red: 0.306, green: 0.467, blue: 0.984, alpha: 1)
//        } else {
//            checkButton.backgroundColor = .white
//        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
