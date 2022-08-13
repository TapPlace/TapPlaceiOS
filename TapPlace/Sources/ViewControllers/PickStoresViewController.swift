//
//  PickStoresViewController.swift
//  TapPlace
//
//  Created by 박상현 on 2022/08/09.
//

import UIKit
import AlignedCollectionViewFlowLayout

class PickStoresViewController: CommonPickViewController {

    var favoriteStores = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        // Do any additional setup after loading the view.
        
        
    }
    



}

//MARK: - Layout
extension PickStoresViewController: TitleViewProtocol, BottomButtonProtocol {
    func didTapBottomButton() {
        if bottomButton.isActive {
            print("액션 실행 가능")
        } else {
            print("액션 실행 불가능")
        }
    }
    
    func didTapTitleViewSkipButton() {
        print("스킵 버튼 눌림")
    }
    
    func didTapTitleViewClearButton() {
        print("초기화 버튼 눌림")
        for i in 0...StoreModel.storeList.count - 1 {
            var indexPath = IndexPath(row: i, section: 0)
            guard let cell = collectionView.cellForItem(at: indexPath) as? PickStoresCollectionViewCell else { return }
            selectCellItem(cell, selected: true, indexPath: indexPath)
        }
        favoriteStores = 0
        bottomButtonUpdate()
    }
    
    /**
     * @ 초기 레이아웃 설정
     * coder : sanghyeon
     */
    private func setupView() {
        //MARK: 델리게이트
        titleView.delegate = self
        bottomButton.delegate = self
        collectionView.delegate = self
        collectionView.dataSource = self
        
        //MARK: 공통 뷰에서 추가된 타이틀뷰 및 하단버튼 설정
        titleView.titleViewText.text = "관심 매장 선택"
        titleView.descLabel.text = "선호하는 매장을 선택하면,\n해당 매장의 간편결제 여부를 알려드릴게요."
        titleView.currentPage = 2
        
        //MARK: 컬렉션뷰 설정
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 20, right: 20)
        collectionView.register(PickStoresCollectionViewCell.self, forCellWithReuseIdentifier: "storesItem")
    }
}
//MARK: - CollectionView
extension PickStoresViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("셀 카운트", StoreModel.storeList.count)
        return StoreModel.storeList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "storesItem", for: indexPath) as! PickStoresCollectionViewCell
        cell.imageView.image = UIImage(named: "storeCafe")!.withRenderingMode(.alwaysTemplate)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("셀 선택 됨")
        guard let cell = collectionView.cellForItem(at: indexPath) as? PickStoresCollectionViewCell else { return }
        
        
        selectCellItem(cell, selected: cell.cellSelected, indexPath: indexPath)
        print("cell.cellSelected:", cell.cellSelected)
        if cell.cellSelected {
            favoriteStores += 1
        } else {
            favoriteStores -= 1
        }

        bottomButtonUpdate()
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = collectionView.frame.width - 40 - 30
        return CGSize(width: cellWidth / 3, height: cellWidth / 3)
    }
    
    /**
     * @ 컬렉션뷰 선택시 UI 변경
     * coder : sanghyeon
     */
    func selectCellItem(_ cell: PickStoresCollectionViewCell, selected: Bool, indexPath: IndexPath) {
        UIView.animate(withDuration: 0.2, delay: 0, animations: {
            let arrRow = selected ? 0 : 1
            cell.imageView.tintColor = self.colorImage[arrRow]
            cell.itemFrame.backgroundColor = self.colorBackground[arrRow]
            cell.itemFrame.layer.borderWidth = self.widthBorder[arrRow]
            cell.itemFrame.layer.borderColor = self.colorBorder[arrRow].cgColor
            cell.itemText.textColor = self.colorText[arrRow]
            cell.cellSelected = self.activeCell[arrRow]
            
            if selected {
                
            } else {
                
            }
        })
    }
    
    
    
    
    /**
     * @ 컬렉션뷰 선택시 선택된 항목 유무에 따라 하단 버튼 작동 로직 구현
     * coder : sanghyeon
     */
    func bottomButtonUpdate() {
        var selectedCount = favoriteStores
        
        print("selectedCount:", selectedCount)
        
        if selectedCount > 0 {
            bottomButton.backgroundColor = .pointBlue
            bottomButton.setTitleColor(.white, for: .normal)
            bottomButton.isActive = true
        } else {
            bottomButton.backgroundColor = .deactiveGray
            bottomButton.setTitleColor(UIColor.init(hex: 0xAFB4C3), for: .normal)
            bottomButton.isActive = false
        }
    }
    
}
