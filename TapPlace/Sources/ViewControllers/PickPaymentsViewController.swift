//
//  PickPaymentsViewController.swift
//  TapPlace
//
//  Created by 박상현 on 2022/08/05.
//

import UIKit
import SnapKit
import AlignedCollectionViewFlowLayout

class PickPaymentsViewController: UIViewController {
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
    let titleView = PickViewControllerTitleView()
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
    /// 하단 버튼
    let bottomButton = BottomButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        print("로드")
        print(samplePayments.count)
        // Do any additional setup after loading the view.
    }
}
//MARK: - Layout
extension PickPaymentsViewController: TitleViewProtocol, BottomButtonProtocol {
    func didTapBottomButton() {
        if bottomButton.isActive {
            print("액션 실행 가능")
        } else {
            print("액션 실행 불가능")
        }
    }
    
    func didTapTitleViewSkipButton() {
        print("스킵 버튼 눌림")
        let vc = PickStoresViewController()
//        vc.modalPresentationStyle = .fullScreen
//        vc.modalTransitionStyle = .coverVertical
//        present(vc, animated: true)
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func didTapTitleViewClearButton() {
        print("초기화 버튼 눌림")
        for i in 0...samplePaymentsTitle.count - 1 {
            selectedPayments[samplePaymentsTitle[i]]?.removeAll()
            for j in 0...samplePayments[samplePaymentsTitle[i]]!.count - 1 {
                let cell = collectionView.cellForItem(at: IndexPath(row: j, section: i)) as! PickPaymentsCollectionViewCell
                cell.cellSelected = false
                cell.itemText.textColor = UIColor.init(hex: 0xB8BDCC)
                cell.itemFrame.backgroundColor = .clear
                cell.itemFrame.layer.borderWidth = 1
                cell.itemFrame.layer.borderColor = UIColor.init(hex: 0xDBDEE8, alpha: 0.5).cgColor
            }
        }
        bottomButtonUpdate()
    }
    
    /**
     * @ 초기 레이아웃 설정
     * coder : sanghyeon
     */
    private func setupView() {
        /// 뷰컨트롤러 배경색 지정
        view.backgroundColor = .white
        self.navigationController?.navigationBar.isHidden = true
        //MARK: 뷰 추가
        view.addSubview(titleView)
        view.addSubview(bottomButton)
        view.addSubview(collectionView)
        titleView.titleViewText.text = "결제수단 설정"
        //MARK: 뷰 제약
        titleView.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(230)
        }
        bottomButton.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-60)
        }
        collectionView.snp.makeConstraints {
            $0.top.equalTo(titleView.snp.bottom)
            $0.bottom.equalTo(bottomButton.snp.top)
            $0.left.trailing.equalTo(view.safeAreaLayoutGuide)
        }
        bottomButton.backgroundColor = .deactiveGray
        bottomButton.setTitle("선택완료", for: .normal)
        bottomButton.setTitleColor(UIColor.init(hex: 0xAFB4C3), for: .normal)
        
        titleView.currentPage = 1
        titleView.descLabel.text = "선택한 결제수단의 가맹점을 우선적으로 찾아드려요.\n설정에서 언제든지 수정할 수 있어요."
        titleView.delegate = self
        bottomButton.delegate = self
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(PickPaymentsCollectionViewCell.self, forCellWithReuseIdentifier: "paymentsItem")
        collectionView.register(PickPaymentsCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "paymentsHeader")
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 20, right: 20)
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
        
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return samplePayments.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("셀 선택 됨")
        guard let cell = collectionView.cellForItem(at: indexPath) as? PickPaymentsCollectionViewCell else { return }
        if cell.cellSelected {
            cell.cellSelected = false
            cell.itemText.textColor = UIColor.init(hex: 0xB8BDCC)
            cell.itemFrame.backgroundColor = .clear
            cell.itemFrame.layer.borderWidth = 1
            cell.itemFrame.layer.borderColor = UIColor.init(hex: 0xDBDEE8, alpha: 0.5).cgColor
            let selectedCurrentPayments: [String] = (selectedPayments[samplePaymentsTitle[indexPath.section]] as? [String])!
            guard let firstIndex = selectedCurrentPayments.firstIndex(of: samplePayments[samplePaymentsTitle[indexPath.section]]![indexPath.row]) else { return }
            selectedPayments[samplePaymentsTitle[indexPath.section]]!.remove(at: firstIndex)
        } else {
            cell.cellSelected = true
            cell.itemText.textColor = .pointBlue
            cell.itemFrame.backgroundColor = UIColor.init(hex: 0x4E77FB, alpha: 0.06)
            cell.itemFrame.layer.borderWidth = 1.5
            cell.itemFrame.layer.borderColor = UIColor.init(hex: 0x4E77FB, alpha: 0.6).cgColor
            selectedPayments[samplePaymentsTitle[indexPath.section]]?.append(samplePayments[samplePaymentsTitle[indexPath.section]]![indexPath.row])
        }
        bottomButtonUpdate()
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            print(samplePaymentsTitle[indexPath.section])
            if samplePaymentsTitle[indexPath.section] == "etc" {
                print("감춰야함")
                return UICollectionReusableView()
            }
            let headerReusableView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "paymentsHeader", for: indexPath) as! PickPaymentsCollectionReusableView
            
            var sectionTitle = "etc"
            switch samplePaymentsTitle[indexPath.section] {
            case "applepay":
                sectionTitle = Payments.applepay.rawValue
            case "googlepay" :
                sectionTitle = Payments.googlepay.rawValue
            case "contactless" :
                sectionTitle = Payments.contactless.rawValue
            default :
                sectionTitle = Payments.etc.rawValue
            }
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
        return CGSize(width: CommonUtils().getTextSizeWidth(text: samplePayments[samplePaymentsTitle[indexPath.section]]![indexPath.row]), height: 36)
    }
    
    
    /**
     * @ 컬렉션뷰 선택시 선택된 항목 유무에 따라 하단 버튼 작동 로직 구현
     * coder : sanghyeon
     */
    func bottomButtonUpdate() {
        var selectedCount = 0
        for i in 0...samplePaymentsTitle.count - 1 {
            selectedCount += selectedPayments[samplePaymentsTitle[i]]!.count
        }
        
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
