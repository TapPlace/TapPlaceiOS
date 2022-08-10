//
//  PickStoresViewController.swift
//  TapPlace
//
//  Created by 박상현 on 2022/08/09.
//

import UIKit
import AlignedCollectionViewFlowLayout

class PickStoresViewController: CommonPickViewController {

    let bottomButton = BottomButton()
    
    /// 관심 매장 컬렉션뷰
    let collectionView: UICollectionView = {
        let collectionViewLayout = AlignedCollectionViewFlowLayout()
        collectionViewLayout.scrollDirection = .vertical
        collectionViewLayout.minimumInteritemSpacing = 15
        collectionViewLayout.minimumLineSpacing = 15
        collectionViewLayout.horizontalAlignment = .left
        //collectionViewLayout.headerReferenceSize = .init(width: 100, height: 40)
        let collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), collectionViewLayout: collectionViewLayout)
        collectionView.backgroundColor = .white
        return collectionView
    }()
    
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
    }
    
    /**
     * @ 초기 레이아웃 설정
     * coder : sanghyeon
     */
    private func setupView() {
        /// 뷰컨트롤러 배경색 지정
        view.backgroundColor = .white
        //MARK: 뷰 추가
        let titleView = PickViewControllerTitleView()
        bottomButton.delegate = self
        view.addSubview(titleView)
        view.addSubview(bottomButton)
        view.addSubview(collectionView)
        //MARK: 뷰 제약
        titleView.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(230)
        }
        titleView.titleViewText.text = "관심 매장 선택"
        titleView.currentPage = 2
        titleView.descLabel.text = "선호하는 매장을 선택하면,\n해당 매장의 간편결제 여부를 알려드릴게요."
        titleView.delegate = self
        
        bottomButton.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-60)
        }
        bottomButton.backgroundColor = .deactiveGray
        bottomButton.setTitle("선택완료", for: .normal)
        bottomButton.setTitleColor(UIColor.init(hex: 0xAFB4C3), for: .normal)
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(titleView.snp.bottom)
            $0.bottom.equalTo(bottomButton.snp.top)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        }
        collectionView.delegate = self
        collectionView.dataSource = self
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
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = collectionView.frame.width - 40 - 30
        return CGSize(width: cellWidth / 3, height: cellWidth / 3)
    }
    
    
    
}
