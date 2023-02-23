//
//  StoreDetailViewController.swift
//  TapPlace
// 
//  Created by 박상현 on 2022/09/12.
//

import UIKit
import Combine
import NMapsMap
import CoreLocation
import SnapKit

class StoreDetailViewController: CommonViewController, CustomToolBarProtocol {
    var storeInfo: StoreInfo?
    
    var isFirstLoaded: Bool = true
    var feedbackList: [Feedback]?
    var naverMapViewHeight: CGFloat = 0
    
    var storeID: String? = "" {
        willSet {
            //guard let newValue = newValue else { return }
            //getStore(store: newValue)
        }
    }
    
    var naverMapView = NMFMapView()
    var backButtonFrame = UIView()
    let scrollView = UIScrollView()
    let contentView = UIView()
    let toolBar = CustomToolBar()
    var storeInfoView = UIView()
    let customNavigationBar = CustomNavigationBar()
    var storeLabel = UILabel()
    var storeCategory = VerticalAlignLabel()
    var storeDetailLabel = UILabel()
    var storeTelLabel = UILabel()
    var storeTelButton = UIButton()
    var feedbackButton = UIButton()
    var separatorView = UIView()
    let requestButton = UIButton()
    var tableView = UITableView()
    var contentViewHeight: CGFloat = 0
    var feedbackVC: UIViewController?
    
    var subscription = Set<AnyCancellable>()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBindings()
        setupNaverMapView()
        setupView()
        setupNavigation()
                
        DispatchQueue.main.async {
            guard let storeInfo = self.storeInfo else { return }
            self.setStore(storeInfo: storeInfo)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.isFirstLoaded = false
            }
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBar?.hideTabBar(hide: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBar?.hideTabBar(hide: false)
    }
    
}

extension StoreDetailViewController: CustomNavigationBarProtocol, CustomToolBarShareProtocol {
    func setBindings() {
        feedbackViewModel.requestRemainFeedbackCount()
        feedbackViewModel.$remainCount.sink { (count: Int) in
            if count == 0 {
                self.feedbackButton.tintColor = .init(hex: 0x333333, alpha: 0.2)
                self.feedbackButton.setTitleColor(.init(hex: 0x333333, alpha: 0.2), for: .normal)
                self.feedbackButton.isEnabled = false
            } else {
                self.feedbackButton.tintColor = .pointBlue
                self.feedbackButton.setTitleColor(.pointBlue, for: .normal)
                self.feedbackButton.isEnabled = true
            }
        }.store(in: &subscription)
    }
    func showShare(storeID: String) {
        NotificationCenter.default.post(name: NSNotification.Name.showShare, object: storeID)
    }
    
    /**
     * @ 초기 레이아웃 설정
     * coder : sanghyeon
     */
    func setupView() {
        //MARK: ViewDefine
        let safeArea = view.safeAreaLayoutGuide
        backButtonFrame = {
            let backButtonFrame = UIView()
            backButtonFrame.backgroundColor = .white
            backButtonFrame.layer.cornerRadius = 20
            backButtonFrame.layer.applySketchShadow(color: .black, alpha: 0.25, x: 0, y: 2, blur: 8, spread: 0)
            return backButtonFrame
        }()
        let backButtonIcon: UIImageView = {
            let backButtonIcon = UIImageView()
            backButtonIcon.image = .init(systemName: "chevron.left")
            backButtonIcon.contentMode = .scaleAspectFit
            backButtonIcon.tintColor = .black
            return backButtonIcon
        }()
        let backButton = UIButton()
        storeInfoView = {
            let storeInfoView = UIView()
            storeInfoView.backgroundColor = .white
            storeInfoView.layer.applySketchShadow(color: .black, alpha: 0.12, x: 0, y: 0, blur: 14, spread: 0)
            storeInfoView.layer.shadowOffset = CGSize(width: 0, height: -10)
            return storeInfoView
        }()
        let storeInfoViewInnerWrap = UIView()
        storeLabel = {
            let storeLabel = UILabel()
            storeLabel.sizeToFit()
            storeLabel.textColor = .black
            storeLabel.font = .systemFont(ofSize: CommonUtils.resizeFontSize(size: 18), weight: .bold)
            storeLabel.text = "가맹점 이름"
            return storeLabel
        }()
        storeCategory = {
            let storeCategory = VerticalAlignLabel()
            storeCategory.verticalAlignment = .bottom
            storeCategory.sizeToFit()
            storeCategory.textColor = .init(hex: 0x9E9E9E)
            storeCategory.font = .systemFont(ofSize: CommonUtils.resizeFontSize(size: 13), weight: .regular)
            storeCategory.text = "카테고리"
            return storeCategory
        }()
        let locationIcon: UIImageView = {
            let locationIcon = UIImageView()
            locationIcon.image = .init(named: "location")?.withRenderingMode(.alwaysTemplate)
            locationIcon.tintColor = .init(hex: 0xDBDEE8)
            locationIcon.contentMode = .scaleAspectFit
            return locationIcon
        }()
        let telephoneIcon: UIImageView = {
            let telephoneIcon = UIImageView()
            telephoneIcon.image = .init(named: "telephone")?.withRenderingMode(.alwaysTemplate).withAlignmentRectInsets(UIEdgeInsets(top: -2, left: -2, bottom: -2, right: -2))
            telephoneIcon.tintColor = .init(hex: 0xDBDEE8)
            telephoneIcon.contentMode = .scaleAspectFit
            return telephoneIcon
        }()
        storeDetailLabel = {
            let storeDetailLabel = UILabel()
            storeDetailLabel.sizeToFit()
            storeDetailLabel.textColor = .init(hex: 0x707070)
            storeDetailLabel.font = .systemFont(ofSize: CommonUtils.resizeFontSize(size: 14), weight: .regular)
            return storeDetailLabel
        }()
        storeTelLabel = {
            let storeTelLabel = UILabel()
            storeTelLabel.sizeToFit()
            storeTelLabel.textColor = .init(hex: 0x707070)
            storeTelLabel.font = .systemFont(ofSize: CommonUtils.resizeFontSize(size: 14), weight: .regular)
            return storeTelLabel
        }()
        let separatorLine: UIView = {
            let separatorLine = UIView()
            separatorLine.backgroundColor = .init(hex: 0xDBDEE8).withAlphaComponent(0.4)
            return separatorLine
        }()
        let requestButtonFrame = UIButton()
        let pencilIcon: UIImageView = {
            let pencilIcon = UIImageView()
            pencilIcon.image = .init(named: "pencil")?.withRenderingMode(.alwaysTemplate).withAlignmentRectInsets(UIEdgeInsets(top: -2, left: -2, bottom: -2, right: -2))
            pencilIcon.tintColor = .init(hex: 0xDBDEE8)
            pencilIcon.contentMode = .scaleAspectFit
            return pencilIcon
        }()
        let requestLabel: UILabel = {
            let requestLabel = UILabel()
            requestLabel.sizeToFit()
            requestLabel.text = "정보 수정 요청"
            requestLabel.font = .systemFont(ofSize: CommonUtils.resizeFontSize(size: 14), weight: .regular)
            requestLabel.textColor = .init(hex: 0x707070)
            return requestLabel
        }()
        let arrowIcon: UIImageView = {
            let arrowIcon = UIImageView()
            arrowIcon.image = .init(systemName: "chevron.forward")
            arrowIcon.tintColor = .init(hex: 0xDBDEE8)
            arrowIcon.contentMode = .scaleAspectFit
            return arrowIcon
        }()
        separatorView = {
            let separatorView = UIView()
            separatorView.backgroundColor = .init(hex: 0xF1F2F7, alpha: 1)
            return separatorView
        }()
        let dummyTableView: UITableView = {
            let dummyTableView = UITableView()
            dummyTableView.rowHeight = 140
            dummyTableView.separatorInset = .zero
            dummyTableView.contentInset = UIEdgeInsets(top: 16, left: 0, bottom: 16, right: 0)
            dummyTableView.isScrollEnabled = false
            return dummyTableView
        }()
        tableView = dummyTableView
        let logoImageView: UIImageView = {
            let logoImageView = UIImageView()
            logoImageView.contentMode = .scaleAspectFit
            logoImageView.image = .init(named: "fullLogo")
            return logoImageView
        }()


        //MARK: ViewPropertyManual
        view.backgroundColor = .white
        storeDetailLabel.text = "거리 · 주소"
        storeTelLabel.text = "가맹점 연락처"

        
        //MARK: AddSubView
        view.addSubview(toolBar)
        view.addSubview(logoImageView)
        backButtonFrame.addSubview(backButtonIcon)
        backButtonFrame.addSubview(backButton)
        contentView.addSubview(storeInfoView)
        view.addSubview(scrollView)
        view.addSubview(backButtonFrame)
        
        scrollView.addSubview(contentView)
        storeInfoView.addSubview(storeInfoViewInnerWrap)
        storeInfoViewInnerWrap.addSubview(storeLabel)
        storeInfoViewInnerWrap.addSubview(storeCategory)
        storeInfoViewInnerWrap.addSubview(locationIcon)
        storeInfoViewInnerWrap.addSubview(telephoneIcon)
        storeInfoViewInnerWrap.addSubview(storeDetailLabel)
        storeInfoViewInnerWrap.addSubview(storeTelLabel)
        storeInfoViewInnerWrap.addSubview(storeTelButton)
        storeInfoViewInnerWrap.addSubview(separatorLine)
        storeInfoViewInnerWrap.addSubview(requestButtonFrame)
        requestButtonFrame.addSubview(pencilIcon)
        requestButtonFrame.addSubview(requestLabel)
        requestButtonFrame.addSubview(arrowIcon)
        requestButtonFrame.addSubview(requestButton)
        contentView.addSubview(separatorView)
        contentView.addSubview(tableView)
        
        
        //MARK: ViewContraints
        logoImageView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(50)
            $0.height.equalTo(20)
            $0.top.equalTo(naverMapView.snp.bottom).offset(50)
        }
        backButtonFrame.snp.makeConstraints {
            $0.top.leading.equalTo(safeArea).inset(20)
            $0.width.height.equalTo(40)
        }
        backButtonIcon.snp.makeConstraints {
            $0.width.height.equalTo(15)
            $0.center.equalTo(backButtonFrame)
        }
        backButton.snp.makeConstraints {
            $0.edges.equalTo(backButtonFrame)
        }
        scrollView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalTo(safeArea)
            $0.bottom.equalTo(toolBar.snp.top)
        }
        toolBar.snp.makeConstraints {
            $0.leading.trailing.bottom.equalTo(safeArea)
            $0.height.equalTo(toolBar.toolBar)
        }
        contentView.snp.makeConstraints {
            $0.edges.equalTo(scrollView)
            $0.width.equalTo(view.frame.width)
            $0.height.equalTo(contentViewHeight)
        }
        storeInfoView.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(contentView)
            $0.bottom.equalTo(requestButtonFrame).offset(10)
        }
        storeInfoViewInnerWrap.snp.makeConstraints {
            $0.leading.trailing.equalTo(storeInfoView).inset(20)
            $0.top.bottom.equalTo(storeInfoView)
        }
        storeLabel.snp.makeConstraints {
            $0.leading.equalTo(storeInfoViewInnerWrap)
            $0.top.equalTo(storeInfoViewInnerWrap).offset(20)
        }
        storeCategory.snp.makeConstraints {
            $0.leading.equalTo(storeLabel.snp.trailing).offset(10)
            $0.top.bottom.equalTo(storeLabel)
        }
        locationIcon.snp.makeConstraints {
            $0.leading.equalTo(storeInfoViewInnerWrap)
            $0.top.equalTo(storeLabel.snp.bottom).offset(20)
            $0.width.height.equalTo(20)
        }
        telephoneIcon.snp.makeConstraints {
            $0.leading.equalTo(storeInfoViewInnerWrap)
            $0.top.equalTo(locationIcon.snp.bottom).offset(10)
            $0.width.height.equalTo(20)
        }
        storeDetailLabel.snp.makeConstraints {
            $0.leading.equalTo(locationIcon.snp.trailing).offset(10)
            $0.centerY.equalTo(locationIcon)
        }
        storeTelLabel.snp.makeConstraints {
            $0.leading.equalTo(storeDetailLabel)
            $0.centerY.equalTo(telephoneIcon)
        }
        storeTelButton.snp.makeConstraints {
            $0.edges.equalTo(storeTelLabel)
        }
        separatorLine.snp.makeConstraints {
            $0.leading.trailing.equalTo(storeInfoViewInnerWrap)
            $0.top.equalTo(telephoneIcon.snp.bottom).offset(10)
            $0.height.equalTo(1)
        }
        requestButtonFrame.snp.makeConstraints {
            $0.leading.trailing.equalTo(storeInfoViewInnerWrap)
            $0.top.equalTo(separatorLine.snp.bottom).offset(10)
            $0.bottom.equalTo(pencilIcon).offset(10)
        }
        pencilIcon.snp.makeConstraints {
            $0.leading.equalTo(requestButtonFrame)
            $0.top.equalTo(requestButtonFrame).offset(5)
            $0.width.height.equalTo(20)
        }
        requestLabel.snp.makeConstraints {
            $0.leading.equalTo(storeTelLabel)
            $0.centerY.equalTo(pencilIcon)
        }
        arrowIcon.snp.makeConstraints {
            $0.trailing.equalTo(requestButtonFrame)
            $0.width.height.equalTo(20)
            $0.centerY.equalTo(requestLabel)
        }
        requestButton.snp.makeConstraints {
            $0.edges.equalTo(requestButtonFrame)
        }
        separatorView.snp.makeConstraints {
            $0.top.equalTo(storeInfoView.snp.bottom)
            $0.leading.trailing.equalTo(storeInfoView)
            $0.height.equalTo(6)
        }
        tableView.snp.makeConstraints {
            $0.top.equalTo(separatorView.snp.bottom)
            $0.leading.trailing.equalTo(contentView)
            if let feedbackList = feedbackList {
                $0.height.equalTo(186 * feedbackList.count)
            }
        }
        
        
        //MARK: ViewAddTarget & Register
        backButton.addTarget(self, action: #selector(popViewController), for: .touchUpInside)
        requestButton.addTarget(self, action: #selector(didTapRequestButton), for: .touchUpInside)
        tableView.register(StorePaymentTableViewCell.self, forCellReuseIdentifier: StorePaymentTableViewCell.identifier)
        
        
        //MARK: Delegate
        tableView.delegate = self
        tableView.dataSource = self
        scrollView.delegate = self
        toolBar.delegate = self
        toolBar.vcDelegate = self
    }
    /**
     * @ 레이아웃 업데이트
     * coder : sanghyeon
     */
    func updateLayout() {
        guard let feedbackList = feedbackList else { return }
        let storeInfoViewHeight: CGFloat = storeInfoView.frame.height
        let headerViewSize: CGFloat = 36 + 36
        let tableViewRowHeight: CGFloat = CGFloat(140 * feedbackList.count)
    
        contentViewHeight = storeInfoViewHeight + headerViewSize + tableViewRowHeight
        
        
        contentView.snp.remakeConstraints {
            $0.edges.equalTo(scrollView)
            $0.width.equalTo(view.frame.width)
            $0.height.equalTo(contentViewHeight)
        }
        tableView.snp.remakeConstraints {
            $0.top.equalTo(separatorView.snp.bottom)
            $0.leading.trailing.equalTo(contentView)
            $0.height.equalTo(186 * feedbackList.count)
        }
    }
    /**
     * @ 네이버맵뷰 설정
     * coder : sanghyeon
     */
    func setupNaverMapView() {
        let safeArea = view.safeAreaLayoutGuide
        var topPadding: CGFloat = 0
        if #available(iOS 11.0, *) {
            let window = UIApplication.shared.keyWindow
            guard let safeAreaTopPadding = window?.safeAreaInsets.top else { return }
            topPadding = safeAreaTopPadding
        }
        naverMapView = NMFMapView(frame: self.view.frame)
        view.addSubview(naverMapView)
        naverMapViewHeight = view.frame.width - 150
        naverMapView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(naverMapViewHeight)
            scrollView.contentInset = UIEdgeInsets(top: naverMapViewHeight - topPadding, left: 0, bottom: 0, right: 0)
        }
        
        naverMapView.isZoomGestureEnabled = false
        naverMapView.isTiltGestureEnabled = false
        naverMapView.isRotateGestureEnabled = false
        naverMapView.isScrollGestureEnabled = false
    }
    /**
     * @ 네비게이션바 세팅
     * coder : sanghyeon
     */
    func setupNavigation() {
        view.addSubview(customNavigationBar)
        customNavigationBar.snp.remakeConstraints {
            let navigationBarHeight = customNavigationBar.frame.height
            $0.top.equalToSuperview().offset(-navigationBarHeight)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(navigationBarHeight)
        }
        customNavigationBar.containerView.snp.remakeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(customNavigationBar)
        }
        customNavigationBar.titleText = "세븐일레븐 염창점"
        customNavigationBar.isUseLeftButton = true
        customNavigationBar.isDrawShadow = false
        
        customNavigationBar.delegate = self
    }
    
    /**
     * @ 넘겨받은 스토어 정보로 화면 채우기
     * coder : sanghyeon
     */
    func setStore(storeInfo: StoreInfo) {
        feedbackList = storeInfo.feedback
        customNavigationBar.titleText = storeInfo.placeName
        storeLabel.text = storeInfo.placeName
        storeCategory.text = storeInfo.categoryGroupName
        storeTelLabel.text = storeInfo.phone == "" ? "정보 없음" : storeInfo.phone
        if storeInfo.phone != "" {
            storeTelButton.addTarget(self, action: #selector(self.didTapTelButton), for: .touchUpInside)
        }
        var storeLocation: CLLocationCoordinate2D?
        var storeDistance: String = "알 수 없음"
        if let x = Double(storeInfo.x), let y = Double(storeInfo.y) {
            storeLocation = CLLocationCoordinate2D(latitude: y, longitude: x)
            /// 맵뷰 설정
            let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(from: storeLocation!))
            naverMapView.moveCamera(cameraUpdate)
            /// 마커 설정
            var markerImageName = "select_etc_pin"
            if let markerModel = MarkerModel.list.first(where: {$0.groupName == storeInfo.categoryGroupName}) {
                markerImageName = "select_\(markerModel.markerImage)"
            }
            let marker: NMFMarker = NMFMarker(position: NMGLatLng(from: storeLocation!), iconImage: NMFOverlayImage(name: markerImageName))
            marker.width = 36
            marker.height = 51
            marker.captionText = storeInfo.placeName
            marker.mapView = self.naverMapView
        }
        if let storeLocation = storeLocation, let userLocation = UserInfo.userLocation {
            storeDistance = DistancelModel.getDistance(distance: storeLocation.distance(from: userLocation))
        }
        let storeAddress = storeInfo.roadAddressName == "" ? storeInfo.addressName : storeInfo.roadAddressName
        storeDetailLabel.text = "\(storeDistance) · \(storeAddress)"
        updateLayout()
        tableView.reloadData()
    }
    
    /**
     * @ 전화걸기
     * coder : sanghyeon
     */
    @objc func didTapTelButton() {
        if let tel = storeTelLabel.text?.replacingOccurrences(of: "-", with: ""), let telUrl = URL(string: "telprompt://\(tel)") {
            if UIApplication.shared.canOpenURL(telUrl) {
                UIApplication.shared.open(telUrl)
            }
        }
    }
    /**
     * @ 정보 수정 요청 버튼 클릭함수
     * coder : sanghyeon
     */
    @objc func didTapRequestButton() {
        let vc = InquiryViewController()
        vc.type = .edit
        vc.storeId = storeInfo?.storeID
        self.navigationController?.pushViewController(vc, animated: true)
    }
    /**
     * @ 네비게이션바 좌측 버튼 클릭함수
     * coder : sanghyeon
     */
    func didTapLeftButton() {
        popViewController()
    }

    /**
     * @ POP VIEW!
     * coder : sanghyeon
     */
    @objc func popViewController() {
        self.navigationController?.popViewController(animated: true)
    }
}

//MARK: - TableView
extension StoreDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let feedbackList = feedbackList else { return 0 }
        return feedbackList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: StorePaymentTableViewCell.identifier, for: indexPath) as? StorePaymentTableViewCell else { return UITableViewCell() }
        guard let feedbackList = feedbackList else { return UITableViewCell() }
        cell.feedback = feedbackList[indexPath.row]
        cell.selectionStyle = .none
        return cell
    }
    
    //MARK: 헤더뷰
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .white
        
        let headerTitleLabel: UILabel = {
            let headerTitleLabel = UILabel()
            headerTitleLabel.sizeToFit()
            headerTitleLabel.text = "결제수단"
            headerTitleLabel.textColor = .black
            headerTitleLabel.font = .systemFont(ofSize: CommonUtils.resizeFontSize(size: 17), weight: .semibold)
            return headerTitleLabel
        }()
        feedbackButton = {
            let feedbackButton = UIButton()
            feedbackButton.setImage(.init(named: "feedback")?.withRenderingMode(.alwaysTemplate), for: .normal)
            feedbackButton.setTitle("나도 피드백 하기", for: .normal)
            feedbackButton.titleLabel?.font = .systemFont(ofSize: CommonUtils.resizeFontSize(size: 15), weight: .semibold)
            feedbackButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -20, bottom: 0, right: 0)
            feedbackButton.setTitleColor(.pointBlue, for: .normal)
            feedbackButton.tintColor = .pointBlue
            return feedbackButton
        }()
        
        feedbackButton.addTarget(self, action: #selector(didTapFeedbackButton), for: .touchUpInside)
        
        headerView.addSubview(headerTitleLabel)
        headerView.addSubview(feedbackButton)
        
        headerTitleLabel.snp.makeConstraints {
            $0.leading.equalTo(headerView).offset(20)
            $0.centerY.equalTo(headerView)
        }
        feedbackButton.snp.makeConstraints {
            $0.trailing.equalTo(headerView).offset(-20)
            $0.centerY.equalTo(headerView)
        }
        
        return headerView
    }
    
    @objc func didTapFeedbackButton() {
        self.feedbackVC = FeedbackRequestViewController()
        if let feedbackVC = self.feedbackVC as? FeedbackRequestViewController {
            feedbackVC.storeInfo = self.storeInfo
            self.navigationController?.pushViewController(feedbackVC, animated: true)
        } else {
            showToast(message: "알 수 없는 문제로 피드백 요청을 불러올 수 없습니다.\n잠시 후 다시 시도해주시기 바랍니다.", view: self.view)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 36
    }
}

//MARK: - ScrollView
extension StoreDetailViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let backButtonOffset = backButtonFrame.frame.minY + backButtonFrame.frame.height + 10
        if scrollView.contentOffset.y >= -(backButtonOffset) {
            backButtonFade(fadeIn: false)
            navigationSlide(slideIn: true)
        } else {
            backButtonFade(fadeIn: true)
            navigationSlide(slideIn: false)
        }
    }
    /**
     * @ 뒤로가기버튼 fade
     * coder : sanghyeon
     */
    func backButtonFade(fadeIn: Bool) {
        if isFirstLoaded { return }
        UIView.animate(withDuration: 0.3, delay: 0) {
            self.backButtonFrame.alpha = fadeIn ? 1 : 0
        }
    }
    /**
     * @ 네비게이션바 슬라이드
     * coder : sanghyeon
     */
    func navigationSlide(slideIn: Bool) {
        let safeArea = view.safeAreaLayoutGuide
        if isFirstLoaded { return }
        if slideIn {
            customNavigationBar.snp.remakeConstraints {
                $0.top.leading.trailing.equalToSuperview()
                $0.bottom.equalTo(customNavigationBar.containerView)
            }
            customNavigationBar.containerView.snp.remakeConstraints {
                $0.leading.trailing.equalToSuperview()
                $0.top.equalTo(safeArea)
                $0.height.equalTo(60)
            }
            customNavigationBar.isDrawShadow = true
        } else {
            customNavigationBar.snp.remakeConstraints {
                let navigationBarHeight = customNavigationBar.frame.height
                $0.top.equalToSuperview().offset(-navigationBarHeight)
                $0.leading.trailing.equalToSuperview()
                $0.height.equalTo(navigationBarHeight)
            }
            customNavigationBar.containerView.snp.remakeConstraints {
                $0.leading.trailing.equalToSuperview()
                $0.bottom.equalTo(customNavigationBar)
            }
            customNavigationBar.isDrawShadow = false
        }
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
}
