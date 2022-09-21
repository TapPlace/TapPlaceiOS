//
//  AroundFilterViewController.swift
//  TapPlace
//
//  Created by 박상현 on 2022/08/23.
//

import UIKit
import AlignedCollectionViewFlowLayout

protocol AroundPlaceApplyFilterProtocol {
    func applyFilter()
}

class AroundFilterViewController: UIViewController {
    
    
    var delegate: AroundPlaceApplyFilterProtocol?
    var storageViewModel = StorageViewModel()
    var isFirstLoaded: Bool = true

    let scrollView = UIScrollView()
    let contentView = UIView()
    let storeResetView = FilterResetButtonView()
    let paymentResetView = FilterResetButtonView()
    
    var tempStores: [StoreModel] = AroundFilterModel.storeList
    var tempPayments: [PaymentModel] = AroundFilterModel.paymentList
    
    let storeCollectionView: UICollectionView = {
        let collectionViewLayout = AlignedCollectionViewFlowLayout()
        collectionViewLayout.scrollDirection = .vertical
        collectionViewLayout.minimumInteritemSpacing = 10
        collectionViewLayout.minimumLineSpacing = 10
        collectionViewLayout.horizontalAlignment = .left
        let storeCollectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), collectionViewLayout: collectionViewLayout)
        storeCollectionView.backgroundColor = .white
        return storeCollectionView
    }()
    
    let paymentCollectionView: UICollectionView = {
        let collectionViewLayout = AlignedCollectionViewFlowLayout()
        collectionViewLayout.scrollDirection = .vertical
        collectionViewLayout.minimumInteritemSpacing = 10
        collectionViewLayout.minimumLineSpacing = 10
        collectionViewLayout.horizontalAlignment = .left
        let paymentCollectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), collectionViewLayout: collectionViewLayout)
        paymentCollectionView.backgroundColor = .white
        return paymentCollectionView
    }()
    
    let bottomButton = BottomButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !isFirstLoaded { return }
        DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
            let storeCollectionViewheight = self.storeCollectionView.contentSize.height
            let paymentCollectionViewheight = self.paymentCollectionView.contentSize.height
            
            self.storeCollectionView.snp.makeConstraints {
                $0.height.equalTo(storeCollectionViewheight)
            }
            self.paymentCollectionView.snp.makeConstraints {
                $0.height.equalTo(paymentCollectionViewheight)
            }
            let unionCalculatedTotalRect = self.recursiveUnionInDepthFor(view: self.scrollView)
            self.contentView.snp.makeConstraints {
                $0.height.equalTo(unionCalculatedTotalRect.height + self.bottomButton.frame.height)
            }
            self.scrollView.contentSize = CGSize(width: self.view.frame.width, height: unionCalculatedTotalRect.height + self.bottomButton.frame.height)
        })
        isFirstLoaded = false
    }
    
    
}
extension AroundFilterViewController: FilterResetProtocol {
    func didTapResetButton(_ sender: UIButton) {
        switch sender {
        case storeResetView.resetButton:
            tempStores.removeAll()
            storeCollectionView.reloadData()
        case paymentResetView.resetButton:
            tempPayments.removeAll()
            paymentCollectionView.reloadData()
        default:
            break
        }
    }
    private func recursiveUnionInDepthFor(view: UIView) -> CGRect {
        var totalRect: CGRect = .zero
        
        // 모든 자식 View의 컨트롤의 크기를 재귀적으로 호출하며 최종 영역의 크기를 설정
        for subView in view.subviews {
            totalRect = totalRect.union(recursiveUnionInDepthFor(view: subView))
        }
        
        // 최종 계산 영역의 크기를 반환
        return totalRect.union(view.frame)
    }

    /**
     * @ 초기 레이아웃 설정
     * coder : sanghyeon
     */
    func setupView() {
        //MARK: ViewDefine
        let safeArea = view.safeAreaLayoutGuide
        let containerView: UIView = {
            let containerView = UIView()
            return containerView
        }()
        let contentWrap: UIView = {
            let contentWrap = UIView()
            contentWrap.backgroundColor = .white
            contentWrap.layer.cornerRadius = 20
            contentWrap.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            contentWrap.layer.masksToBounds = true
            return contentWrap
        }()
        let titleView: UIView = {
            let titleView = UIView()
            return titleView
        }()
        let titleLabel: UILabel = {
            let titleLabel = UILabel()
            titleLabel.text = "필터"
            titleLabel.textColor = .black
            titleLabel.textAlignment = .center
            titleLabel.font = .systemFont(ofSize: CommonUtils.resizeFontSize(size: 15), weight: .semibold)
            titleLabel.sizeToFit()
            return titleLabel
        }()
        let closeButton: UIButton = {
            let closeButton = UIButton()
            closeButton.setImage(UIImage(systemName: "xmark"), for: .normal)
            closeButton.tintColor = .black
            return closeButton
        }()
        
        
        //MARK: ViewPropertyManual
        bottomButton.setButtonStyle(title: "적용", type: .activate, fill: true)
        storeResetView.resetLabel.text = "매장선택"
        paymentResetView.resetLabel.text = "결제수단"
        storeCollectionView.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        paymentCollectionView.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        
        
        //MARK: AddSubView
        view.addSubview(containerView)
        containerView.addSubview(contentWrap)
        contentWrap.addSubview(titleView)
        titleView.addSubview(titleLabel)
        titleView.addSubview(closeButton)
        contentWrap.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(storeResetView)
        contentView.addSubview(storeCollectionView)
        contentView.addSubview(paymentResetView)
        contentView.addSubview(paymentCollectionView)
        containerView.addSubview(bottomButton)
        
        //MARK: ViewContraints
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            //$0.top.equalTo(safeArea.snp.bottom).offset(-250)
        }
        contentWrap.snp.makeConstraints {
            $0.leading.trailing.equalTo(containerView)
            $0.bottom.equalTo(bottomButton.snp.top)
            $0.top.equalTo(safeArea).offset(80)
        }
        titleView.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(contentWrap)
            $0.bottom.equalTo(titleLabel).offset(15)
        }
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(titleView).offset(15)
            $0.leading.trailing.equalTo(titleView)
        }
        closeButton.snp.makeConstraints {
            $0.centerY.equalTo(titleLabel)
            $0.trailing.equalTo(titleView).offset(-20)
        }
        scrollView.snp.makeConstraints {
            $0.top.equalTo(titleView.snp.bottom)
            $0.leading.trailing.equalTo(safeArea)
            $0.bottom.equalTo(bottomButton.snp.top)
        }
        contentView.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(scrollView)
            $0.width.equalTo(view.frame.width)
            
        }
        storeResetView.snp.makeConstraints {
            $0.leading.trailing.equalTo(scrollView).inset(20)
            $0.top.equalTo(scrollView)
            $0.height.equalTo(50)
        }
        storeCollectionView.snp.makeConstraints {
            $0.leading.trailing.equalTo(contentView)
            $0.top.equalTo(storeResetView.snp.bottom)
        }
        paymentResetView.snp.makeConstraints {
            $0.leading.trailing.equalTo(scrollView).inset(20)
            $0.top.equalTo(storeCollectionView.snp.bottom).offset(10)
            $0.height.equalTo(50)
        }
        paymentCollectionView.snp.makeConstraints {
            $0.leading.trailing.equalTo(contentView)
            $0.top.equalTo(paymentResetView.snp.bottom)
        }
        bottomButton.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.top.equalTo(safeArea.snp.bottom).offset(-50)
        }
        
        
        
        //MARK: ViewAddTarget & Register
        storeCollectionView.register(PickPaymentsCollectionViewCell.self, forCellWithReuseIdentifier: "distanceItem")
        paymentCollectionView.register(PickPaymentsCollectionViewCell.self, forCellWithReuseIdentifier: "paymentsItem")
        paymentCollectionView.register(PickPaymentsCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "paymentsHeader")
        closeButton.addTarget(self, action: #selector(didTapCloseButton), for: .touchUpInside)
        bottomButton.addTarget(self, action: #selector(didTapBottonButton), for: .touchUpInside)
        
        
        //MARK: Delegate
        storeCollectionView.delegate = self
        storeCollectionView.dataSource = self
        paymentCollectionView.dataSource = self
        paymentCollectionView.delegate = self
        storeResetView.delegate = self
        paymentResetView.delegate = self
        
        

    }
    
    @objc func didTapCloseButton() {
        self.dismiss(animated: true)
    }
    @objc func didTapBottonButton() {
        AroundFilterModel.storeList = tempStores
        AroundFilterModel.paymentList = tempPayments
        delegate?.applyFilter()
        NotificationCenter.default.post(name: NSNotification.Name.applyAroundFilter, object: nil)
        self.dismiss(animated: true)
    }
}
//MARK: - CollectionView
extension AroundFilterViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        switch collectionView {
        case storeCollectionView:
            return 1
        case paymentCollectionView:
            return EasyPaymentModel.list.count
        default:
            return 0
        }
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case storeCollectionView:
            return StoreModel.lists.count
        case paymentCollectionView:
            let paymentList = storageViewModel.userFavoritePayments.filter({$0.payments == EasyPaymentModel.list[section].designation})
            return paymentList.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case storeCollectionView:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "distanceItem", for: indexPath) as? PickPaymentsCollectionViewCell else { return UICollectionViewCell() }
            cell.itemText.text = StoreModel.lists[indexPath.row].title
            cell.cellVariable = StoreModel.lists[indexPath.row].id
            
            if let _ = tempStores.first(where: {$0.id == cell.cellVariable}) {
                cell.cellSelected = true
            }
            return cell
        case paymentCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "paymentsItem", for: indexPath) as! PickPaymentsCollectionViewCell
            let paymentList = storageViewModel.userFavoritePayments.filter({$0.payments == EasyPaymentModel.list[indexPath.section].designation})

            let cellText = paymentList[indexPath.row].payments == "" ? paymentList[indexPath.row].designation : paymentList[indexPath.row].brand
            let cellVariable = paymentList[indexPath.row].payments == "" ? paymentList[indexPath.row].brand : paymentList[indexPath.row].payments + "_" + paymentList[indexPath.row].brand
            
            cell.itemText.text = cellText.uppercased()
            cell.cellVariable = cellVariable
            
            guard let targetCell = PaymentModel.thisPayment(payment: cellVariable) else { return cell }
            
            if let _ = tempPayments.first(where: {$0.brand == targetCell.brand && $0.payments == targetCell.payments}) {
                cell.cellSelected = true
            }

            return cell
        default:
            return UICollectionViewCell()
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
        case storeCollectionView:
            guard let cell = storeCollectionView.cellForItem(at: indexPath) as? PickPaymentsCollectionViewCell else { return }
            cell.cellSelected.toggle()
            if cell.cellSelected {
                guard let targetStore = StoreModel.lists.firstIndex(where: { $0.id == cell.cellVariable }) else { return }
                tempStores.append(StoreModel.lists[targetStore])
            } else {
                guard let targetStore = tempStores.firstIndex(where: {$0.id == cell.cellVariable}) else { return }
                tempStores.remove(at: targetStore)
            }
            return
        case paymentCollectionView:
            guard let cell = paymentCollectionView.cellForItem(at: indexPath) as? PickPaymentsCollectionViewCell else { return }
            cell.cellSelected.toggle()
            if cell.cellSelected {
                guard let targetPayment = PaymentModel.thisPayment(payment: cell.cellVariable) else { return }
                tempPayments.append(targetPayment)
            } else {
                guard let targetPayment = PaymentModel.thisPayment(payment: cell.cellVariable) else { return }
                guard let removePayment = tempPayments.firstIndex(where: {$0.brand == targetPayment.brand && $0.payments == targetPayment.payments}) else { return }
                tempPayments.remove(at: removePayment)
            }
            return
        default:
            return
        }
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch collectionView {
        case storeCollectionView:
            return UICollectionReusableView()
        case paymentCollectionView:
            switch kind {
            case UICollectionView.elementKindSectionHeader:
                if EasyPaymentModel.list[indexPath.section].designation == "" || storageViewModel.userFavoritePayments.filter({$0.payments == EasyPaymentModel.list[indexPath.section].designation}).count == 0 {
                    return UICollectionReusableView()
                }
                let headerReusableView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "paymentsHeader", for: indexPath) as! PickPaymentsCollectionReusableView
                
                let sectionTitle = EasyPaymentModel.list[indexPath.section].krDesignation
                headerReusableView.prepare(title: sectionTitle)
                return headerReusableView
            default:
                return UICollectionReusableView()
            }
        default:
            return UICollectionReusableView()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if collectionView != paymentCollectionView {
            return .zero
        }
        let indexPath = IndexPath(row: 0, section: section)
        let headerView = self.collectionView(collectionView, viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader, at: indexPath)
        return headerView.systemLayoutSizeFitting(CGSize(width: paymentCollectionView.frame.width, height: 60), withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)
    }
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView {
        case storeCollectionView:
            let labelSize = CommonUtils.getTextSizeWidth(text: StoreModel.lists[indexPath.row].title)
            return CGSize(width: labelSize.width + 40, height: 36)
        case paymentCollectionView:
            let sectionTitle = EasyPaymentModel.list[indexPath.section].designation
            var cellText = ""
            switch sectionTitle {
            case "":
                cellText = storageViewModel.userFavoritePayments.filter({$0.payments == sectionTitle})[indexPath.row].designation
            default:
                cellText = storageViewModel.userFavoritePayments.filter({$0.payments == sectionTitle})[indexPath.row].brand.uppercased()
            }
            let labelSize = CommonUtils.getTextSizeWidth(text: cellText)
            return CGSize(width: labelSize.width + 40, height: 36)
        default:
            return .zero
        }
    }
    

    
}

