//
//  AroundDistanceFilterViewController.swift
//  TapPlace
//
//  Created by 박상현 on 2022/08/22.
//

import UIKit
import AlignedCollectionViewFlowLayout

protocol AroundDistanceFilterProtocol {
    func setDistanceLabel()
}

class AroundDistanceFilterViewController: UIViewController {
    
    static var delegate: AroundDistanceFilterProtocol?
    
    var distanceRow = 0
    var selectedDistance = 1000
    
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
    let bottomButton = BottomButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        findDistanceRow()
        setupView()
        
        print(DistancelModel.lists)
        
    }
    
    
}
extension AroundDistanceFilterViewController {
    /**
     * @ 설정된 반경 row값 찾기
     * coder : sanghyeon
     */
    func findDistanceRow() {
        for i in 0...DistancelModel.lists.count - 1 {
            if DistancelModel.lists[i].distance == DistancelModel.selectedDistance {
                distanceRow = i
            }
        }
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
            titleLabel.text = "반경설정"
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
        bottomButton.backgroundColor = .pointBlue
        bottomButton.setTitle("적용", for: .normal)
        bottomButton.setTitleColor(.white, for: .normal)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        
        
        //MARK: AddSubView
        view.addSubview(containerView)
        containerView.addSubview(contentWrap)
        contentWrap.addSubview(titleView)
        titleView.addSubview(titleLabel)
        titleView.addSubview(closeButton)
        contentWrap.addSubview(collectionView)
        containerView.addSubview(bottomButton)
        
        //MARK: ViewContraints
        containerView.snp.makeConstraints {
            $0.top.bottom.leading.trailing.equalToSuperview()
            //$0.top.equalTo(safeArea.snp.bottom).offset(-250)
        }
        contentWrap.snp.makeConstraints {
            $0.leading.trailing.equalTo(containerView)
            $0.bottom.equalTo(bottomButton.snp.top)
            $0.height.equalTo(150)
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
        collectionView.snp.makeConstraints {
            $0.leading.trailing.equalTo(contentWrap)
            $0.top.equalTo(titleView.snp.bottom)
            $0.height.equalTo(100)
        }
        bottomButton.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.top.equalTo(safeArea.snp.bottom).offset(-60)
        }
        
        
        
        //MARK: ViewAddTarget & Register
        collectionView.register(PickPaymentsCollectionViewCell.self, forCellWithReuseIdentifier: "distanceItem")
        closeButton.addTarget(self, action: #selector(didTapCloseButton), for: .touchUpInside)
        bottomButton.addTarget(self, action: #selector(didTapBottonButton), for: .touchUpInside)
        
        
        //MARK: Delegate
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    @objc func didTapCloseButton() {
        self.dismiss(animated: true)
    }
    @objc func didTapBottonButton() {
        /// 반경 저장 코드 작성하기
        DistancelModel.selectedDistance = selectedDistance
        AroundDistanceFilterViewController.delegate?.setDistanceLabel()
        self.dismiss(animated: true)
    }
}
//MARK: - CollectionView
extension AroundDistanceFilterViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return DistancelModel.lists.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "distanceItem", for: indexPath) as? PickPaymentsCollectionViewCell else { return UICollectionViewCell() }
        cell.itemText.text = DistancelModel.lists[indexPath.row].title
        cell.cellVariable = String(DistancelModel.lists[indexPath.row].distance)
        if indexPath.row == distanceRow {
            cell.cellSelected = true
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        for i in 0...DistancelModel.lists.count - 1 {
            guard let cell = collectionView.cellForItem(at: IndexPath(row: i, section: 0)) as? PickPaymentsCollectionViewCell else { return }
            cell.cellSelected = false
        }
        guard let selectedCell = collectionView.cellForItem(at: indexPath) as? PickPaymentsCollectionViewCell else { return }
        selectedCell.cellSelected = true
        selectedCell.cellVariable = String(DistancelModel.lists[indexPath.row].distance)
        if let returnDistance = Int(selectedCell.cellVariable) {
            selectedDistance = returnDistance
        } else {
            selectedDistance = 1000
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let labelSize = CommonUtils.getTextSizeWidth(text: DistancelModel.lists[indexPath.row].title)
        return CGSize(width: labelSize.width + 40, height: 36)
    }
    

    
}
