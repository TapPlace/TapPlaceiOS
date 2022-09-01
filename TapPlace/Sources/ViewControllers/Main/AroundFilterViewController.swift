//
//  AroundFilterViewController.swift
//  TapPlace
//
//  Created by 박상현 on 2022/08/23.
//

import UIKit

//
//  AroundDistanceFilterViewController.swift
//  TapPlace
//
//  Created by 박상현 on 2022/08/22.
//

import UIKit
import AlignedCollectionViewFlowLayout

class AroundFilterViewController: UIViewController {
    

    let scrollView = UIScrollView()
    
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
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            let storeCollectionViewheight = self.storeCollectionView.contentSize.height
            UIView.animate(withDuration: 1, delay: 0, animations: {
                self.storeCollectionView.snp.makeConstraints {
                    $0.height.equalTo(storeCollectionViewheight)
                }
            })

        })
        
    }
    
    
}
extension AroundFilterViewController {

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
        
        let contentView = UIView()
        let storeResetView = FilterResetButtonView()
        let paymentResetView = FilterResetButtonView()
        
        
        //MARK: ViewPropertyManual
        bottomButton.backgroundColor = .pointBlue
        bottomButton.setTitle("적용", for: .normal)
        bottomButton.setTitleColor(.white, for: .normal)
        storeResetView.resetLabel.text = "매장선택"
        paymentResetView.resetLabel.text = "결제수단"
        storeCollectionView.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        paymentCollectionView.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        storeCollectionView.backgroundColor = .pointBlue
        
        
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
        containerView.addSubview(paymentCollectionView)
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
            $0.edges.equalTo(scrollView)
            $0.width.equalTo(view.frame.width)
            $0.height.equalTo(view.frame.height + 100)
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
            $0.top.equalTo(paymentResetView)
        }
        bottomButton.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.top.equalTo(safeArea.snp.bottom).offset(-60)
        }
        
        
        
        //MARK: ViewAddTarget & Register
        storeCollectionView.register(PickPaymentsCollectionViewCell.self, forCellWithReuseIdentifier: "distanceItem")
        closeButton.addTarget(self, action: #selector(didTapCloseButton), for: .touchUpInside)
        bottomButton.addTarget(self, action: #selector(didTapBottonButton), for: .touchUpInside)
        
        
        //MARK: Delegate
        storeCollectionView.delegate = self
        storeCollectionView.dataSource = self
        paymentCollectionView.dataSource = self
        paymentCollectionView.delegate = self
        
        

    }
    
    @objc func didTapCloseButton() {
        self.dismiss(animated: true)
    }
    @objc func didTapBottonButton() {
        /// 반경 저장 코드 작성하기
        self.dismiss(animated: true)
    }
}
//MARK: - CollectionView
extension AroundFilterViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case storeCollectionView:
            return DistancelModel.lists.count
        default:
            return 10
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "distanceItem", for: indexPath) as? PickPaymentsCollectionViewCell else { return UICollectionViewCell() }
        cell.itemText.text = DistancelModel.lists[indexPath.row].title
        cell.cellVariable = String(DistancelModel.lists[indexPath.row].distance)
//        if indexPath.row == distanceRow {
//            cell.cellSelected = true
//        }
        return cell
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView {
        case storeCollectionView:
            let labelSize = CommonUtils.getTextSizeWidth(text: DistancelModel.lists[indexPath.row].title)
            return CGSize(width: labelSize.width + 40, height: 36)
        default:
            return CGSize(width: 0, height: 0)
        }
    }
    

    
}

