//
//  PickPaymentsViewController.swift
//  TapPlace
//
//  Created by 박상현 on 2022/08/05.
//

import UIKit
import SnapKit
import AlignedCollectionViewFlowLayout

class PickPaymentsViewController: CommonPickViewController {
    var favoritePayments = 0
    let samplePayments = [
        "etc": ["카카오페이", "네이버페이", "제로페이", "페이코"],
        "applepay": ["VISA", "MASTER CARD", "JCB"],
        "googlepay": ["VISA", "MASTER CARD", "MAESTRO"],
        "contactless": ["VISA", "MASTER CARD", "Union Pay", "AMERICAN EXPRESS (AMEX)", "JCB"]
    ]
    var selectedPayments = [
        "etc": [],
        "applepay": [],
        "googlepay": [],
        "contactless": []
    ]
    let samplePaymentsTitle = ["etc", "applepay", "googlepay", "contactless"]


    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
}
//MARK: - Layout
extension PickPaymentsViewController: TitleViewProtocol, BottomButtonProtocol {
    func didTapBottomButton() {
        if bottomButton.isActive {
            print("액션 실행 가능")
            let vc = TabBarViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            print("액션 실행 불가능")
        }
    }
    
    func didTapTitleViewSkipButton() {
        print("스킵 버튼 눌림")
        let vc = MainViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func didTapTitleViewClearButton() {
        print("초기화 버튼 눌림")
        for i in 0...samplePaymentsTitle.count - 1 {
            selectedPayments[samplePaymentsTitle[i]]?.removeAll()
            for j in 0...samplePayments[samplePaymentsTitle[i]]!.count - 1 {
                var indexPath = IndexPath(row: j, section: i)
                let cell = collectionView.cellForItem(at: indexPath) as! PickPaymentsCollectionViewCell
                cell.cellSelected = false
            }
        }
        favoritePayments = 0
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
        titleView.titleViewText.text = "결제수단 설정"
        titleView.descLabel.text = "선택한 결제수단의 가맹점을 우선적으로 찾아드려요.\n설정에서 언제든지 수정할 수 있어요."

        //MARK: 컬렉션뷰 설정
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 20, right: 20)
        collectionView.register(PickPaymentsCollectionViewCell.self, forCellWithReuseIdentifier: "paymentsItem")
        collectionView.register(PickPaymentsCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "paymentsHeader")
    }
}
//MARK: - CollectionView
extension PickPaymentsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return samplePayments[samplePaymentsTitle[section]]!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "paymentsItem", for: indexPath) as! PickPaymentsCollectionViewCell
        cell.itemText.text = samplePayments[samplePaymentsTitle[indexPath.section]]![indexPath.row]
        cell.cellVariable = samplePayments[samplePaymentsTitle[indexPath.section]]![indexPath.row]
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return samplePayments.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("셀 선택 됨")
        if favoritePayments >= 5 {
            print("5개가 이미 선택 됨.")
            return
        }
        guard let cell = collectionView.cellForItem(at: indexPath) as? PickPaymentsCollectionViewCell else { return }
        
        UIView.animate(withDuration: 0.5, delay: 0, animations: {
            
            print("cell.cellSelected:", cell.cellSelected)
            if cell.cellSelected {
                print("셀 꺼짐")
                cell.cellSelected = false
                self.favoritePayments -= 1
            } else {
                cell.cellSelected = true
                self.favoritePayments += 1
            }
        })
        print(cell.cellVariable)
        bottomButtonUpdate()
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            if samplePaymentsTitle[indexPath.section] == "etc" {
                print("감춰야함")
                return UICollectionReusableView()
            }
            let headerReusableView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "paymentsHeader", for: indexPath) as! PickPaymentsCollectionReusableView
            
            let sectionTitle = EasyPaymentModel.list[indexPath.section].krDesignation
            headerReusableView.prepare(title: sectionTitle)
            return headerReusableView
        default:
            return UICollectionReusableView()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let indexPath = IndexPath(row: 0, section: section)
        let headerView = self.collectionView(collectionView, viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader, at: indexPath)
        return headerView.systemLayoutSizeFitting(CGSize(width: collectionView.frame.width, height: 60), withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let labelSize = CommonUtils.getTextSizeWidth(text: samplePayments[samplePaymentsTitle[indexPath.section]]![indexPath.row])
        return CGSize(width: labelSize.width + 40, height: 36)
    }
    
    /**
     * @ 컬렉션뷰 선택시 UI 변경
     * coder : sanghyeon
     */
    func selectCellItem(_ cell: PickPaymentsCollectionViewCell, selected: Bool, indexPath: IndexPath) {
        UIView.animate(withDuration: 0.2, delay: 0, animations: {

        })
    }
    
    /**
     * @ 컬렉션뷰 선택시 선택된 항목 유무에 따라 하단 버튼 작동 로직 구현
     * coder : sanghyeon
     */
    func bottomButtonUpdate() {
        var selectedCount = favoritePayments
        
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
