//
//  CommonPickViewController.swift
//  TapPlace
//
//  Created by 박상현 on 2022/08/11.
//

import UIKit
import AlignedCollectionViewFlowLayout

//MARK: - PickPayments, PickStores 뷰컨트롤러 공통
class CommonPickViewController: UIViewController {


    

    
    //MARK: 뷰 요소 선언
    let titleView = PickViewControllerTitleView()
    let bottomButton = BottomButton()
    /// 결제수단 컬렉션뷰
    let collectionView: UICollectionView = {
        let collectionViewLayout = AlignedCollectionViewFlowLayout()
        collectionViewLayout.scrollDirection = .vertical
        collectionViewLayout.minimumInteritemSpacing = 10
        collectionViewLayout.minimumLineSpacing = 10
        collectionViewLayout.horizontalAlignment = .left
        //collectionViewLayout.headerReferenceSize = .init(width: 100, height: 40)
        let collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), collectionViewLayout: collectionViewLayout)
        collectionView.backgroundColor = .white
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCommonView()

    }
    
    override func viewDidAppear(_ animated: Bool) {

    }
}

extension CommonPickViewController {
    /**
     * @ 초기 레이아웃 설정
     * coder : sanghyeon
     */
    func setupCommonView() {
        //MARK: 뷰 속성 변경
        view.backgroundColor = .white
        self.navigationController?.navigationBar.isHidden = true
        
        //MARK: 뷰 추가
        view.addSubview(titleView)
        view.addSubview(bottomButton)
        view.addSubview(collectionView)
        
        //MARK: 뷰 제약
        titleView.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(180)
        }
        bottomButton.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-50)
        }
        collectionView.snp.makeConstraints {
            $0.top.equalTo(titleView.snp.bottom)
            $0.bottom.equalTo(bottomButton.snp.top)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        }
        
        bottomButton.setButtonStyle(title: "선택완료", type: .disabled, fill: true)

    }
}
