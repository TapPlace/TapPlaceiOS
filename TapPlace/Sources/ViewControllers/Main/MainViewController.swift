//
//  MainViewController.swift
//  TapPlace
//
//  Created by 박상현 on 2022/08/05.
//

import UIKit
import AlignedCollectionViewFlowLayout
import NMapsMap
import CoreLocation
import SnapKit
import FloatingPanel

class MainViewController: CommonViewController {
    
    var aroundStoreList: [AroundStores]?
    
    /// 메인모드인가?
    var isMainMode: Bool = true
    /// 메인모드에서는 storeInfo의 정보를 필히 받아야 하며, showNavigation, showDetailOverView 함수 사용만을 권장함
    var storeInfo: StoreInfo?
    /// 처음으로 실행되었는가?
    var isFirstLaunched: Bool = true
    
    let customNavigationBar = CustomNavigationBar()
    var naverMapView: NMFMapView = NMFMapView()
    var circleOverlay: NMFCircleOverlay = NMFCircleOverlay()
    var searchBar = UIView()
    let researchButton = ResearchButton()
    var detailOverView: DetailOverView?
    var closeButton = UIButton()
    let listButton = MapButton()
    let locationButton = MapButton()
    var overlayCenterPick = SearchMarkerPin()
    var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    var fpc: FloatingPanelController!
    var isHiddenFloatingPanel = true
    let locationManager = CLLocationManager()
    var currentLocation: NMGLatLng?
    var cameraLocation: NMGLatLng?
    var markerList: [AroundStoreMarkerModel] = []
    var latestSelectStore: StoreTabCollectionViewCell?

    
    //MARK: ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupNaverMap()
        setupFloatingPanel()
        mainModeCheck()
        if isMainMode {
            mainViewController = self
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if isMainMode {
            showDetailOverView(hide: true)
            hideNavigationBar(hide: true)
        }

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBar?.hideTabBar(hide: isMainMode ? false : true)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if isFirstLaunched {
            checkLocationAuth()
            isFirstLaunched.toggle()
        }
    }
}

//MARK: - Layout
extension MainViewController: MapButtonProtocol, ResearchButtonProtocol, CustomNavigationBarProtocol {
    func didTapLeftButton() {
        self.navigationController?.popViewController(animated: true)
    }
    
    /**
     * @ 메인모드 여부에 따라서 다른 UI를 구성할 것
     * coder : sanghyeon
     */
    func mainModeCheck() {
        switch isMainMode {
        case true:
            break
        case false:
            /**
             * 메인모드 아닌경우 처리되는 부분
             * 검색창 및 카테고리 탭 삭제
             * 하단 맵버튼 삭제 (리스트버튼)
             * 탭바 숨김처리
             */
            if let storeInfo = storeInfo {
                tabBar?.hideTabBar(hide: true)
                searchBar.isHidden = true
                collectionView.isHidden = true
                listButton.isHidden = true
                hideNavigationBar(hide: false, title: storeInfo.placeName)

                var targetStoreInfo = storeInfo
                storeViewModel.requestStoreInfoCheck(searchModel: AroundStoreModel.convertSearchModel(storeInfo: storeInfo), pays: storageViewModel.userFavoritePaymentsString) { result in
                    targetStoreInfo.feedback = result
                    self.showDetailOverView(hide: false, storeInfo: targetStoreInfo)
                }
                
                
                showDetailOverView(hide: false, storeInfo: storeInfo)
                if let detailOverView = detailOverView {
                    detailOverView.storeInfo = storeInfo
                }
                if let x = Double(storeInfo.x), let y = Double(storeInfo.y) {
                    let storeLocation = CLLocationCoordinate2D(latitude: y, longitude: x)
                    moveCamera(location: storeLocation.toNMGLatLng(), duration: 0, zoom: 17)
                    let marker = NMFMarker(position: storeLocation.toNMGLatLng())
                    marker.mapView = naverMapView
                    marker.captionText = storeInfo.placeName
                    marker.captionRequestedWidth = 50
                }
            } else {
                /// storeInfo 정보가 없다면 바로 뒤로가기
                /// 만에하나 이 뷰컨트롤러밖에 없다면 새로운 메인뷰컨트롤러를 엽시다
                if let vcStacks = self.navigationController?.viewControllers {
                    if vcStacks[0] == self {
                        self.dismiss(animated: false)
                        self.present(MainViewController(), animated: true)
                    } else {
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }
        }
    }
    func didTapResearchButton() {
        guard let camLocation = cameraLocation else { return }
        showInMapViewTracking(location: camLocation)
        showResearchElement(hide: true)
        let clLocation = CLLocationCoordinate2D(latitude: camLocation.lat, longitude: camLocation.lng)
        searchAroundStore(location: clLocation)
        UserInfo.cameraLocation = clLocation
    }
    /**
     * @ 우측 하단 맵 버튼 클릭 함수
     * coder : sanghyeon
     */
    @objc func didTapMapButton(_ sender: MapButton) {
        if sender == listButton.button {
            showFloatingPanel()
        } else if sender == locationButton.button {
            getUserCurrentLocation()
            guard let location = currentLocation else { return }
            moveCamera(location: location)
            if isMainMode { // 메인모드에서만 실행
                showInMapViewTracking(location: location)
                searchAroundStore(location: UserInfo.userLocation)
                showResearchElement(hide: true)
                showDetailOverView(hide: true)
                resetAllMarkersSize()
            }
        }
    }
    /**
     * @ 검색창 클릭시 액션
     * coder : sanghyeon
     */
    @objc func didTapSearchButton() {
        let vc = SearchViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    /**
     * @ 초기 레이아웃 설정
     * coder : sanghyeon
     */
    func setupView() {
        //MARK: ViewDefine
        let safeArea = view.safeAreaLayoutGuide
        let searchIcon: UIImageView = {
            let searchIcon = UIImageView()
            searchIcon.image = UIImage(systemName: "magnifyingglass")
            searchIcon.tintColor = .black
            searchIcon.layer.opacity = 0.8
            return searchIcon
        }()
        let searchButton: UIButton = {
            let searchButton = UIButton()
            searchButton.setTitle("가맹점을 찾아보세요", for: .normal)
            searchButton.setTitleColor(UIColor.init(hex: 0x000000, alpha: 0.3), for: .normal)
            searchButton.setTitleColor(UIColor.init(hex: 0x000000, alpha: 0.1), for: .highlighted)
            searchButton.titleLabel?.font = .systemFont(ofSize: CommonUtils.resizeFontSize(size: 16), weight: .regular)
            searchButton.contentHorizontalAlignment = .left
            return searchButton
        }()
        searchBar = {
            let searchBar = UIView()
            searchBar.backgroundColor = .white
            searchBar.layer.cornerRadius = 15
            searchBar.layer.applySketchShadow(color: .black, alpha: 0.12, x: 0, y: 4, blur: 8, spread: 0)
            return searchBar
        }()
        collectionView = {
            let collectionViewLayout = UICollectionViewFlowLayout()
            collectionViewLayout.scrollDirection = .horizontal
            collectionViewLayout.minimumInteritemSpacing = 5
            collectionViewLayout.minimumLineSpacing = 0
            let collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), collectionViewLayout: collectionViewLayout)
            collectionView.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
            collectionView.backgroundColor = .clear
            collectionView.showsHorizontalScrollIndicator = false
            return collectionView
        }()
        

        //MARK: ViewPropertyManual
        view.backgroundColor = .white
        self.navigationController?.navigationBar.isHidden = true
        listButton.iconName = "list"
        listButton.layer.applySketchShadow(color: .black, alpha: 0.12, x: 0, y: 1, blur: 8, spread: 0)
        locationButton.iconName = "currentLocation"
        locationButton.layer.applySketchShadow(color: .black, alpha: 0.12, x: 0, y: 1, blur: 8, spread: 0)
        overlayCenterPick.isHidden = true
        researchButton.isHidden = true
        researchButton.layer.applySketchShadow(color: .black, alpha: 0.16, x: 0, y: 2, blur: 4, spread: 0)
        
        
        //MARK: AddSubView
        view.addSubview(searchBar)
        searchBar.addSubview(searchIcon)
        searchBar.addSubview(searchButton)
        view.addSubview(collectionView)
        view.addSubview(listButton)
        view.addSubview(locationButton)
        view.addSubview(overlayCenterPick)
        view.addSubview(researchButton)
        
        
        //MARK: ViewContraints
        searchBar.snp.makeConstraints {
            $0.top.equalTo(safeArea).offset(10)
            $0.leading.equalTo(safeArea).offset(20)
            $0.trailing.equalTo(safeArea).offset(-20)
            $0.height.equalTo(50)
        }
        searchIcon.snp.makeConstraints {
            $0.leading.equalTo(searchBar).offset(15)
            $0.centerY.equalTo(searchBar)
            $0.width.height.equalTo(20)
        }
        searchButton.snp.makeConstraints {
            $0.top.bottom.trailing.equalTo(searchBar)
            $0.leading.equalTo(searchIcon.snp.trailing).offset(10)
        }
        collectionView.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom).offset(10)
            $0.leading.trailing.equalTo(safeArea)
            $0.height.equalTo(40)
        }
        listButton.snp.makeConstraints {
            $0.bottom.equalTo(safeArea).offset(-40)
            $0.trailing.equalTo(safeArea).offset(-20)
            $0.width.height.equalTo(40)
        }
        locationButton.snp.makeConstraints {
            $0.bottom.equalTo(listButton.snp.top).offset(-10)
            $0.trailing.equalTo(listButton)
            $0.width.height.equalTo(40)
        }
        overlayCenterPick.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.height.equalTo(10)
        }
        researchButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalTo(listButton)
            $0.leading.trailing.equalTo(researchButton.buttonFrame)
            $0.height.equalTo(35)
        }

        
        //MARK: ViewAddTarget & Register
        searchButton.addTarget(self, action: #selector(didTapSearchButton), for: .touchUpInside)
        collectionView.register(StoreTabCollectionViewCell.self, forCellWithReuseIdentifier: StoreTabCollectionViewCell.cellId)
        
        
        //MARK: Delegate
        listButton.delegate = self
        locationButton.delegate = self
        researchButton.delegate = self
        collectionView.delegate = self
        collectionView.dataSource = self
        
        
        //MARK: ViewModel
        PaymentModel.favoriteList = storageViewModel.userFavoritePayments

    }

    /**
     * @ 메인 뷰컨트롤러 오버퓨 표시
     * param : storeID 및 네비게이션 표시 여부
     * coder : sanghyeon
     */
    func showStoreInfo(storeID: String, isShowNavigation: Bool = true) {
        showDetailOverView(hide: false)
        if isShowNavigation {
            hideNavigationBar(hide: false, title: "스토어 이름")
        }
    }

}
//MARK: - NaverMap
extension MainViewController: CLLocationManagerDelegate, NMFMapViewCameraDelegate, NMFMapViewTouchDelegate {
    /**
     * @ 네이버맵 세팅
     * coder : sanghyeon
     */
    func setupNaverMap() {
        //MARK: NaverMapViewDefine
        naverMapView = NMFMapView(frame: view.frame)
        
        //MARK: NaverMapViewAddSubView
        view.addSubview(naverMapView)
        view.sendSubviewToBack(naverMapView)
        
        //MARK: LocationAuthRequest
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        //MARK: GetUserCurrentLocation & MoveCamera
        if isMainMode { /// 메인모드 아닌경우 실행하지 않음
            getUserCurrentLocation()
            guard let location = currentLocation else { return }
            moveCamera(location: location)
            showInMapViewTracking(location: location)
        }
        //MARK: NaverMapViewDelegate
        naverMapView.addCameraDelegate(delegate: self)
        naverMapView.touchDelegate = self
    }
    /**
     * @ 사용자 현재 위치 가져오기
     * coder : sanghyeon
     */
    func getUserCurrentLocation() {
        guard let result = locationManager.location?.coordinate else { return }
        currentLocation = NMGLatLng(from: result)
        UserInfo.userLocation = result
        UserInfo.cameraLocation = result
        if isMainMode { // 메인모드에서만 실행
            print("*** back MainVC")
            searchAroundStore(location: result)
        }
    }
    /**
     * @ 네이버지도 카메라 이동
     * coder : sanghyeon
     */
    func moveCamera(location: NMGLatLng, duration: TimeInterval = 1, zoom: Double = 14.0) {
        let cameraUpdate = NMFCameraUpdate(scrollTo: location, zoomTo: zoom)
        cameraUpdate.animation = .easeIn
        cameraUpdate.animationDuration = duration
        naverMapView.moveCamera(cameraUpdate)
    }
    /**
     * @ 트래킹 표시 및 반경 오버레이
     * coder : sanghyeon
     */
    func showInMapViewTracking(location: NMGLatLng) {
        //print("현재위치 가져오기: showInMapViewTracking")
        //getUserCurrentLocation()
        guard let trackingLocation = UserInfo.userLocation else { return }
        /// 트래킹 아이콘
        let locationOverlay = naverMapView.locationOverlay
        locationOverlay.location = NMGLatLng(from: trackingLocation)
        locationOverlay.circleOutlineWidth = 0
        locationOverlay.hidden = false
        locationOverlay.subIcon = nil
        /// 반경 설정
        circleOverlay.mapView = nil
        circleOverlay = NMFCircleOverlay(location, radius: 1000)
        circleOverlay.fillColor = .pointBlue.withAlphaComponent(0.03)
        circleOverlay.outlineWidth = 1
        circleOverlay.outlineColor = .pointBlue.withAlphaComponent(0.5)
        circleOverlay.mapView = naverMapView
    }
    /**
     * @ 지도에 마커 추가
     * coder : sanghyeon
     */
    
    func addMarker(markers: [AroundStores]) {
        for marker in markerList {
            marker.marker.mapView = nil
        }
        markerList.removeAll()
        if markers.count <= 0 { return }
        for markerRow in markers {
            if let x = Double(markerRow.x), let y = Double(markerRow.y) {
                let markerPosition = NMGLatLng(lat: y, lng: x)
                let naverMapMarker = NMFMarker(position: markerPosition)
                naverMapMarker.isHideCollidedMarkers = true
                naverMapMarker.mapView = naverMapView
                if let markerImage = MarkerModel.list.first(where: {$0.groupName == markerRow.categoryGroupName}) {
                    naverMapMarker.iconImage = NMFOverlayImage(name: markerImage.markerImage)
                }
                naverMapMarker.captionText = markerRow.placeName
                naverMapMarker.captionRequestedWidth = 80
                naverMapMarker.isHideCollidedCaptions = true
                naverMapMarker.width = 36
                naverMapMarker.height = 48
                naverMapMarker.zIndex = 10000
                naverMapMarker.touchHandler = { (marker) in
                    if let marker = marker as? NMFMarker {
                        self.didTapMarker(marker: marker)
                    }
                    return true
                }
                markerList.append(AroundStoreMarkerModel(store: markerRow, marker: naverMapMarker))
            }
        }
    }
    /**
     * @ 마커 숨기기 (삭제X, 숨기기O)
     * coder : sanghyeon
     */
    func hideMarker(marker: NMFMarker?) {
        if let marker = marker {
            marker.mapView = nil
        } else {
            for addedMarker in markerList {
                addedMarker.marker.mapView = naverMapView
            }
        }
    }
    /**
     * @ 지도상 마커 사이즈 초기화
     * coder : sanghyeon
     */
    func resetAllMarkersSize() {
        for eachMarker in markerList {
            if let markerImage = MarkerModel.list.first(where: {$0.groupName == eachMarker.store.categoryGroupName}) {
                eachMarker.marker.iconImage = NMFOverlayImage(name: markerImage.markerImage)
                eachMarker.marker.zIndex = 10000
            }
            eachMarker.marker.width = 36
            eachMarker.marker.height = 48
        }
    }
    /**
     * @ 마커 클릭 이벤트
     * coder : sanghyeon
     */
    func didTapMarker(marker: NMFMarker?) {
        if !isMainMode { return } /// 메인모드 아닌경우 실행하지 않음
        /// 열려있는 오버뷰 닫기
        showDetailOverView(hide: true)
        /// 모든 마커 사이즈 초기화
        resetAllMarkersSize()
        /// 선택된 마커 사이즈 확장
        guard let marker = marker else { return }
        marker.width = 51
        marker.height = 72
        marker.zIndex = 10001
        
        /// 마커의 스토어 정보
        guard let targetMarker = markerList.first(where: {$0.marker == marker }) else { return }
        let targetStore = targetMarker.store
        
        if let markerImage = MarkerModel.list.first(where: {$0.groupName == targetStore.categoryGroupName}) {
            targetMarker.marker.iconImage = NMFOverlayImage(name: "select_\(markerImage.markerImage)")
        }
        
//        print("클릭된 마커의 스토어: ", targetStore.placeName)
        /// AroundStores -> StoreInfo 변환
        var targetStoreInfo = StoreInfo.convertAroundStores(aroundStore: targetStore)
        storeViewModel.requestStoreInfoCheck(searchModel: AroundStoreModel.convertSearchModel(storeInfo: targetStoreInfo), pays: storageViewModel.userFavoritePaymentsString) { result in
            targetStoreInfo.feedback = result
            self.showDetailOverView(hide: false, storeInfo: targetStoreInfo)
        }
    }
    //MARK: NaverMapView Tap Event
    func mapView(_ mapView: NMFMapView, didTapMap latlng: NMGLatLng, point: CGPoint) {
//        print("*** Touched Point Location: \(latlng)")
    }
    
    func mapView(_ mapView: NMFMapView, didTap symbol: NMFSymbol) -> Bool {
//        print("*** Touched Point Symbol")
        dump(symbol)
        return true
    }
    
    
    
    //MARK: Camera
    func mapViewCameraIdle(_ mapView: NMFMapView) {
        let camPosition = naverMapView.cameraPosition
        cameraLocation = camPosition.target
    }
    func mapView(_ mapView: NMFMapView, cameraDidChangeByReason reason: Int, animated: Bool) {
        if reason != -1 { return }
        showResearchElement(hide: false)
    }
    
    //MARK: Auth
    /**
     * @ 위치권한 설정
     * coder : sanghyeon
     */
    func checkLocationAuth() {
        let status = authorization.getLocationAuthorizationStatus()
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            self.locationManager.startUpdatingLocation()
            if isMainMode { /// 메인모드 아닌경우 실행하지 않음
                getUserCurrentLocation()
            }
            guard let userLocation = UserInfo.userLocation else { return }
            showInMapViewTracking(location: NMGLatLng(from: userLocation))
        case .restricted, .notDetermined:
            authorization.requestLocationAuthorization()
        case .denied:
            let alertController = UIAlertController(title: "위치권한이 거부되었습니다.", message: "위치권한 거부시 정상적으로 앱을 이용하실 수 없습니다. 앱 설정 화면으로 이동하시겠습니까?", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "네", style: .default, handler: { (action) -> Void in
                if let appSettings = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(appSettings, options: [:], completionHandler: nil)
                }
            }))
            alertController.addAction(UIAlertAction(title: "아니오", style: .cancel, handler: { (action) -> Void in
                
            }))
            self.present(alertController, animated: true, completion: nil)
        default: break
        }
    }
    /**
     * @ 권한이 변경 되었을때 현재 위치로 이동
     * coder : sanghyeon
     */
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if CLLocationManager.authorizationStatus() == .authorizedAlways || CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            if isMainMode { /// 메인모드 아닌경우 실행하지 않음
                getUserCurrentLocation()
                guard let userLocation = UserInfo.userLocation else { return }
                showInMapViewTracking(location: NMGLatLng(from: userLocation))
                moveCamera(location: NMGLatLng(from: userLocation))
            }
        }
    }
    /**
     * @ 재검색 관련 UI 토글
     * coder : sanghyeon
     */
    func showResearchElement(hide: Bool) {
        if !isMainMode { return } /// 메인모드 아닌경우 실행하지 않음
        if hide {
            overlayCenterPick.isHidden = true
            researchButton.isHidden = true
        } else {
            self.overlayCenterPick.isHidden = false
            self.researchButton.isHidden = false
        }
    }
}

//MARK: - Delegate Other VC
extension MainViewController: CustomToolBarShareProtocol, StoreInfoViewDelegate {
    /**
     * @ 스토어 상세 뷰컨 이동
     * coder : sanghyeon
     */ 
    func moveStoreDetail(store: StoreInfo) {
        let vc = StoreDetailViewController()
        print("*** vc: \(vc)")
        print("*** 상세뷰 이동")
        vc.storeInfo = store
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    /**
     * @ 공유하기
     * coder : sanghyeon
     */
    func showShare(storeID: String) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "showShare"), object: storeID)
    }
    
    /**
     * @ 상세뷰 오버 뷰
     * coder : sanghyeon
     */
    func showDetailOverView(hide: Bool, storeInfo: StoreInfo? = nil) {
        guard let tabBar = self.tabBarController as? TabBarViewController else { return }
        if hide {
            guard let detailOverView = detailOverView else { return }
            detailOverView.removeFromSuperview()
            closeButton.removeFromSuperview()
            detailOverView.snp.removeConstraints()
            tabBar.hideTabBar(hide: false)
            locationButton.snp.remakeConstraints {
                $0.bottom.equalTo(listButton.snp.top).offset(-20)
                $0.trailing.equalTo(view.safeAreaLayoutGuide).offset(-20)
                $0.width.height.equalTo(40)
            }
            tabBar.hideTabBar(hide: false)
        } else {
            detailOverView = DetailOverView()
            guard let detailOverView = detailOverView else { return }
            fpc.move(to: .hidden, animated: true)
            closeButton = {
                let closeButton = UIButton()
                closeButton.setImage(UIImage(systemName: "xmark"), for: .normal)
                closeButton.tintColor = .black
                return closeButton
            }()
            closeButton.addTarget(self, action: #selector(didTapDetailOverViewCloseButton), for: .touchUpInside)
            view.addSubview(detailOverView)
            detailOverView.addSubview(closeButton)
            detailOverView.snp.makeConstraints {
                $0.leading.trailing.bottom.equalToSuperview()
                $0.top.equalTo(detailOverView.storeInfoView)
            }
            closeButton.snp.makeConstraints {
                $0.trailing.equalTo(detailOverView).offset(-20)
                $0.centerY.equalTo(detailOverView.storeInfoView.storeLabel)
                $0.width.height.equalTo(20)
            }
            
            detailOverView.storeInfoView.titleSize = .large
            detailOverView.toolBar.vcDelegate = self
            detailOverView.storeInfoView.delegate = self

            if let storeInfo = storeInfo {
                detailOverView.storeInfo = storeInfo
            }

            detailOverView.layer.shadowColor = UIColor.black.cgColor
            detailOverView.layer.shadowOpacity = 0.20
            detailOverView.layer.shadowOffset = .zero
            detailOverView.layer.shadowRadius = 14
            detailOverView.layer.cornerRadius = 20
            detailOverView.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMinYCorner, .layerMaxXMinYCorner)
            
            //detailOverView.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMinYCorner, .layerMaxXMinYCorner)
            locationButton.snp.remakeConstraints {
                $0.bottom.equalTo(detailOverView.snp.top).offset(-20)
                $0.trailing.equalTo(view.safeAreaLayoutGuide).offset(-20)
                $0.width.height.equalTo(40)
            }
            tabBar.hideTabBar(hide: true)
        }
    }
    @objc func didTapDetailOverViewCloseButton() {
        if isMainMode {
            showDetailOverView(hide: true)
        } else {
            popToMainViewController()
        }
    }
    /**
     * @ 네비게이션바 표시
     * coder : sanghyeon
     */
    func hideNavigationBar(hide: Bool, title: String = "") {
        if hide {
            customNavigationBar.removeFromSuperview()
            searchBar.isHidden = false
            collectionView.isHidden = false
        } else {
            searchBar.isHidden = true
            collectionView.isHidden = true
            let rightButton: UIButton = {
                let rightButton = UIButton()
                rightButton.tintColor = .black
                rightButton.setImage(UIImage(systemName: "xmark"), for: .normal)
                rightButton.addTarget(self, action: #selector(didTapNavigationRightButton), for: .touchUpInside)
                return rightButton
            }()
            
            view.addSubview(customNavigationBar)
            customNavigationBar.addSubview(rightButton)
            customNavigationBar.snp.makeConstraints {
                $0.top.leading.trailing.equalToSuperview()
                $0.bottom.equalTo(customNavigationBar.containerView)
            }
            rightButton.snp.makeConstraints {
                $0.trailing.equalTo(customNavigationBar).offset(-10)
                $0.bottom.equalTo(customNavigationBar).offset(-10)
                $0.width.height.equalTo(30)
            }
            customNavigationBar.titleText = title
            customNavigationBar.isUseLeftButton = true
            customNavigationBar.isDrawShadow = true
            customNavigationBar.delegate = self
        }
    }
    /**
     * @ 네비게이션바 우측 버튼 클릭 함수
     * coder : sanghyeon
     */
    @objc func didTapNavigationRightButton() {
        popToMainViewController()
    }
    /**
     * @ 메인으로 이동
     * coder : sanghyeon
     */
    func popToMainViewController() {
        /// 제일 앞 뷰컨으로 옮깁시다(MainVC)
        /// 만에하나 메인 뷰컨이 없다면 새로운 메인뷰컨트롤러를 엽시다
        if let vcStacks = self.navigationController?.viewControllers {
            if let _ = vcStacks.first(where: {$0 == mainViewController}) {
                self.navigationController?.popToRootViewController(animated: false)
            } else {
                self.dismiss(animated: false)
                self.present(MainViewController(),animated: true)
            }
        }
    }
}
//MARK: - 뷰모델 함수
extension MainViewController {
    /**
     * @ 좌표 기준으로 주변 매장 검색 후 마커 표시
     * coder : sanghyeon
     */
    func searchAroundStore(location: CLLocationCoordinate2D?) {
        guard let location = location else { return }
        storeViewModel.requestAroundStore(location: location, pays: storageViewModel.userFavoritePaymentsString) { result in
            guard let result = result else { return }
            AroundStoreModel.list = result.stores
            self.addMarker(markers: result.stores)
        }
    }
}


//MARK: - CollectionView
extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    /// 컬렉션뷰 셀 개수 반환
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return StoreModel.lists.count
    }
    /// 컬렉션뷰 셀 설정
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StoreTabCollectionViewCell.cellId, for: indexPath) as! StoreTabCollectionViewCell
        if let icon = UIImage(named: StoreModel.lists[indexPath.row].id) {
            cell.icon = icon
            cell.iconColor = StoreModel.lists[indexPath.row].color
        } 
        cell.itemText.text = StoreModel.lists[indexPath.row].title
        cell.storeId = StoreModel.lists[indexPath.row].id
        return cell
    }
    /// 컬렉션뷰 선택시 필터 적용
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? StoreTabCollectionViewCell else { return }
        latestSelectStore?.cellSelected = false
        /// 이미 선택 된 셀을 클릭했을때
        if cell == latestSelectStore {
            latestSelectStore = nil
            hideMarker(marker: nil)
            return
        } else {
            cell.cellSelected = true
            latestSelectStore = cell
            hideMarker(marker: nil)
            let storeCategory = cell.itemText.text == "기타" ? "" : cell.itemText.text
            for marker in markerList {
                
                if marker.store.categoryGroupName != storeCategory {
                    hideMarker(marker: marker.marker)
                }
            }
        }
    }
    /// 컬렉션뷰 셀 라벨 사이즈 대비 사이즈 변경
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let labelSize = CommonUtils.getTextSizeWidth(text: StoreModel.lists[indexPath.row].title)
        return CGSize(width: labelSize.width + 35, height: 28)
    }
}


//MARK: - Floating Panel
extension MainViewController: FloatingPanelControllerDelegate, AroundPlaceMainControllerProtocol {
    /**
     * @ 플로팅패널 확장 함수
     * coder : sanghyeon
     */
    func expendFloatingPanel() {
        fpc.move(to: .full, animated: true)
    }
    /**
     * @ 플로팅패널 설정
     * coder : sanghyeon
     */
    func setupFloatingPanel() {        
        fpc = FloatingPanelController()
        fpc.delegate = self
        fpc.surfaceView.grabberHandlePadding = 10.0
        fpc.surfaceView.grabberHandleSize = .init(width: 44.0, height: 4.0)
        fpc.backdropView.dismissalTapGestureRecognizer.isEnabled = true
        fpc.contentMode = .fitToBounds
        
        // Create a new appearance.
        let appearance = SurfaceAppearance()
        appearance.cornerRadius = 20.0
        appearance.backgroundColor = .white

        // Set the new appearance
        fpc.surfaceView.appearance = appearance
    }
    func floatingPanel(_ vc: FloatingPanelController, layoutFor newCollection: UITraitCollection) -> FloatingPanelLayout {
            return MainFloatingPanelLayout()
    }
    func floatingPanelDidChangeState(_ fpc: FloatingPanelController) {
        if fpc.state == .hidden {
            fpc.surfaceView.grabberHandle.isHidden = false
        }
    }
    /**
     * @ 플로팅패널 보이기
     * coder : sanghyeon
     */
    func showFloatingPanel(type: FloatingPanelState = .half) {
        /// addPanel의 경우 뷰컨을 새로 로드하기 때문에, removesubview한게 사라짐
        /// 그래서 상태에 따라서 addpanel및 set을 따로 줌
        if fpc.state == type { return }
        if fpc.state == .hidden {
            let contentVC = AroundPlaceViewController()
            fpc.addPanel(toParent: self)
            fpc.track(scrollView: contentVC.aroundPlaceListView.tableView)
            fpc.set(contentViewController: contentVC)
            contentVC.aroundPlaceListView.mainDelegate = self
        }
        fpc.move(to: type, animated: true)
    }
    /**
     * @ 그래버 숨기기
     * coder : sanghyeon
     */
    func hideGrabber(hide: Bool = false) {
        fpc.surfaceView.grabberHandle.isHidden = hide
    }
}

class MainFloatingPanelLayout: FloatingPanelLayout {
    let position: FloatingPanelPosition = .bottom
    let initialState: FloatingPanelState = .hidden
    var anchors: [FloatingPanel.FloatingPanelState : FloatingPanel.FloatingPanelLayoutAnchoring]{
        return [
            .full: FloatingPanelLayoutAnchor(absoluteInset: 110.0, edge: .top, referenceGuide: .safeArea),
            .half: FloatingPanelLayoutAnchor(fractionalInset: 0.29, edge: .bottom, referenceGuide: .safeArea),
            .hidden: FloatingPanelLayoutAnchor(absoluteInset: 0, edge: .bottom, referenceGuide: .safeArea),
        ]
    }
    func backdropAlpha(for state: FloatingPanelState) -> CGFloat {
        switch state {
        case .full: return 0.7
        default: return 0.0
        }
    }
}
