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
    var isEditMode: Bool = false
    var selectedPayments: [String] = []
    
    var storageViewModel = StorageViewModel()
    var userViewModel = UserViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
}
//MARK: - Layout
extension PickPaymentsViewController: BottomButtonProtocol, TitleViewProtocol, CustomNavigationBarProtocol {
    func didTapLeftButton() {
        if isEditMode {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func didTapTitleViewClearButton() {
        selectedPayments.removeAll()
        collectionView.reloadData()
        bottomButtonUpdate()
    }
    
    
    func didTapBottomButton() {
        if bottomButton.isActive {
//            print("액션 실행 가능")
            storageViewModel.setPayments(selectedPayments)
            if isEditMode {
                self.navigationController?.popViewController(animated: true)
            } else {
                let vc = TabBarViewController()
                vc.modalTransitionStyle = .crossDissolve
                vc.modalPresentationStyle = .fullScreen
                
                userViewModel.sendUserInfo(user: storageViewModel.getUserInfo(uuid: Constants.keyChainDeviceID)!, payments: selectedPayments) { result in
                    self.present(vc, animated: true)
                }
            }
        } else {
            showToast(message: "최소 1개의 결제수단을 선택하세요.", view: self.view)
        }
    }
    
    /**
     * @ 초기 레이아웃 설정
     * coder : sanghyeon
     */
    private func setupView() {
        //MARK: 네비게이션바 설정
        self.navigationController?.navigationBar.isHidden = true
        customNavigationBar.titleText = "결제수단 선택"
        customNavigationBar.isUseLeftButton = isEditMode
        customNavigationBar.delegate = self
        
        //MARK: 델리게이트
        bottomButton.delegate = self
        collectionView.delegate = self
        collectionView.dataSource = self
        titleView.delegate = self
        
        //MARK: 공통 뷰에서 추가된 타이틀뷰 및 하단버튼 설정
        titleView.descLabel.text = "선택한 결제수단의 가맹점을 우선적으로 찾아드려요.\n설정에서 언제든지 수정할 수 있어요."
        
        //MARK: 컬렉션뷰 설정
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 20, right: 20)
        collectionView.register(PickPaymentsCollectionViewCell.self, forCellWithReuseIdentifier: "paymentsItem")
        collectionView.register(PickPaymentsCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "paymentsHeader")
        
        //MARK: 수정모드에서는 기존에 선택된 결제수단 표시
        selectedPayments = storageViewModel.userFavoritePaymentsString
        collectionView.reloadData()
    }
}
//MARK: - CollectionView
extension PickPaymentsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let paymentList = PaymentModel.list.filter({$0.payments == EasyPaymentModel.list[section].designation})
        return paymentList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "paymentsItem", for: indexPath) as! PickPaymentsCollectionViewCell
        let paymentList = PaymentModel.list.filter({$0.payments == EasyPaymentModel.list[indexPath.section].designation})
        if paymentList[indexPath.row].payments == "" {
            cell.itemText.text = paymentList[indexPath.row].designation
            cell.cellVariable = paymentList[indexPath.row].brand
        } else {
            cell.itemText.text = paymentList[indexPath.row].brand.uppercased()
            cell.cellVariable = paymentList[indexPath.row].payments + "_" + paymentList[indexPath.row].brand
        }
        
        if selectedPayments.contains(cell.cellVariable) {
            cell.cellSelected = true
        }
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return EasyPaymentModel.list.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        print("셀 선택 됨")
        guard let cell = collectionView.cellForItem(at: indexPath) as? PickPaymentsCollectionViewCell else { return }
        let sectionTitle = EasyPaymentModel.list[indexPath.section].designation

        if !cell.cellSelected {
            if selectedPayments.count >= 5 {
                showToast(message: "결제수단은 5개를 초과할 수 없습니다.", view: self.view)
                return
            }
            selectedPayments.append(cell.cellVariable)
        } else {
            guard let targetPayments = selectedPayments.firstIndex(where: {$0 == cell.cellVariable}) else { return }
//            print(targetPayments)
            selectedPayments.remove(at: targetPayments)
        }
        
        UIView.animate(withDuration: 0.5, delay: 0, animations: {
            cell.cellSelected.toggle()
        })
        
//        print(selectedPayments) 
        bottomButtonUpdate()
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            if EasyPaymentModel.list[indexPath.section].designation == "" {
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
        let sectionTitle = EasyPaymentModel.list[indexPath.section].designation
        var cellText = ""
        switch sectionTitle {
        case "":
            cellText = PaymentModel.list.filter({$0.payments == sectionTitle})[indexPath.row].designation
        default:
            cellText = PaymentModel.list.filter({$0.payments == sectionTitle})[indexPath.row].brand.uppercased()
        }
        let labelSize = CommonUtils.getTextSizeWidth(text: cellText)
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
        if selectedPayments.count > 0 {
            bottomButton.setButtonStyle(title: "선택완료", type: .activate, fill: true)
            bottomButton.isActive = true
        } else {
            bottomButton.setButtonStyle(title: "선택완료", type: .disabled, fill: true)
            bottomButton.isActive = false
        }
    }
}
