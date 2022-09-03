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
    
    var storageViewModel = StorageViewModel()
    
    var fpc: FloatingPanelController!
    var isHiddenFloatingPanel = true
    
    let listButton = MapButton()
    let locationButton = MapButton()

    var naverMapView: NMFMapView = NMFMapView()
    var naverMapMarker: NMFMarker = NMFMarker()
    var circleOverlay: NMFCircleOverlay = NMFCircleOverlay()
    
    let overlayCenterPick: UIView = {
        let overlayCenterPick = UIView()
        overlayCenterPick.layer.borderColor = UIColor.red.cgColor
        overlayCenterPick.layer.borderWidth = 2
        overlayCenterPick.isHidden = true
        return overlayCenterPick
    }()
    let locationManager = CLLocationManager()
    let researchButton = ResearchButton()
    let detailOverView = DetailOverView()
    let collectionView: UICollectionView = {
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

    
    /**
     * @ 더미데이터
     * coder : sanghyeon
     */
    struct DummyData {
        static let markers: [NMGLatLng] = [
            NMGLatLng(lat: 35.97411, lng: 126.68252),
            NMGLatLng(lat: 35.97727, lng: 126.68345),
            NMGLatLng(lat: 35.97827, lng: 126.67731)
        ]
    }
    
    var currentLocation: NMGLatLng?
    var cameraLocation: NMGLatLng?


    let storeLists = StoreModel.lists


    
    //MARK: ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupNaverMap()
        setupFloatingPanel()
        
        print(PaymentModel.favoriteList)
    }
    
}

//MARK: - Floating Panel
extension MainViewController: FloatingPanelControllerDelegate, AroundPlaceMainControllerProtocol {
    func expendFloatingPanel() {
        fpc.move(to: .full, animated: true)
    }
    // 플로팅 패널
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
    
    func floatingPanelWillEndDragging(_ fpc: FloatingPanelController, withVelocity velocity: CGPoint, targetState: UnsafeMutablePointer<FloatingPanelState>) {
        if targetState.pointee == .hidden {
            guard let tabBar = self.tabBarController as? TabBarViewController else { return }
            tabBar.showTabBar(hide: false)
        }
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

//MARK: - Layout
extension MainViewController: MapButtonProtocol, ResearchButtonProtocol {
    func didTapResearchButton() {
        print("재검색 버튼 터치")
        guard let camLocation = cameraLocation else { return }
        showInMapViewTracking(location: camLocation)
        print("현재위치: \(currentLocation!), 카메라위치: \(camLocation)")
        showResearchElement(hide: true)
    }
    
    @objc func didTapMapButton(_ sender: MapButton) {
        print("맵버튼 터치")
        if sender == listButton.button {
            print("리스트 버튼 클릭")
            showFloatingPanel()
            
        } else if sender == locationButton.button {
            getUserCurrentLocation()
            guard let location = currentLocation else { return }
            moveCamera(location: location)
            showInMapViewTracking(location: location)
            showResearchElement(hide: true)
        }
    } // Function: 맵뷰버튼 클릭 이벤트    
    /**
     * @ 검색창 클릭시 액션
     * coder : sanghyeon
     */
    @objc func didTapSearchButton() {
        let vc = SearchViewController()
//        vc.modalTransitionStyle = .crossDissolve
//        vc.modalPresentationStyle = .fullScreen
//        self.present(vc, animated: true)
        self.navigationController?.pushViewController(vc, animated: true)
    } // Function: 서치바 클릭 이벤트
    /**
     * @ 초기 레이아웃 설정
     * coder : sanghyeon
     */
    func setupView() {
        /// 뷰컨트롤러 배경색 지정
        view.backgroundColor = .white
        self.navigationController?.navigationBar.isHidden = true
        
        //MARK: ViewDefine
        let safeArea = view.safeAreaLayoutGuide
        let searchBar: UIView = {
            let searchBar = UIView()
            searchBar.backgroundColor = .white
            searchBar.layer.cornerRadius = 15
            searchBar.layer.applySketchShadow(color: .black, alpha: 0.12, x: 0, y: 4, blur: 8, spread: 0)
            return searchBar
        }()
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


        
        //MARK: ViewPropertyManual
        listButton.iconName = "list.bullet"
        listButton.layer.applySketchShadow(color: .black, alpha: 0.12, x: 0, y: 1, blur: 8, spread: 0)
        locationButton.iconName = "location"
        locationButton.layer.applySketchShadow(color: .black, alpha: 0.12, x: 0, y: 1, blur: 8, spread: 0)
        overlayCenterPick.isHidden = true
        researchButton.isHidden = true
        researchButton.layer.applySketchShadow(color: .black, alpha: 0.12, x: 0, y: 1, blur: 8, spread: 0)
        
        
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
            $0.width.height.equalTo(20)
        }
        researchButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalTo(listButton)
            $0.width.equalTo(150)
            $0.height.equalTo(30)
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

    } // Function: 레이아웃 설정
    

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }

}
//MARK: - NaverMap
extension MainViewController: CLLocationManagerDelegate, NMFMapViewCameraDelegate {
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
        getUserCurrentLocation()
        guard let location = currentLocation else { return }
        moveCamera(location: location)
        showInMapViewTracking(location: location)
        
        //MARK: NaverMapViewDelegate
        naverMapView.addCameraDelegate(delegate: self)
        
        //MARK: [DEBUG]
        // 마커 추가 예제
        addMarker(markers: DummyData.markers)
    }
    /**
     * @ 사용자 현재 위치 가져오기
     * coder : sanghyeon
     */
    func getUserCurrentLocation() {
        guard let result = locationManager.location?.coordinate else { return }
        currentLocation = NMGLatLng(from: result)
        dump(currentLocation)
    }
    /**
     * @ 네이버지도 카메라 이동
     * coder : sanghyeon
     */
    func moveCamera(location: NMGLatLng) {
        let cameraUpdate = NMFCameraUpdate(scrollTo: location, zoomTo: 14.0)
        cameraUpdate.animation = .easeIn
        cameraUpdate.animationDuration = 1
        naverMapView.moveCamera(cameraUpdate)
    }
    /**
     * @ 트래킹 표시 및 반경 오버레이
     * coder : sanghyeon
     */
    func showInMapViewTracking(location: NMGLatLng) {
        getUserCurrentLocation()
        guard let trackingLocation = currentLocation else { return }
        /// 트래킹
        let locationOverlay = naverMapView.locationOverlay
        locationOverlay.location = trackingLocation
        locationOverlay.circleOutlineWidth = 0
        locationOverlay.hidden = false
        locationOverlay.subIcon = nil
        
        /// 반경
        circleOverlay.mapView = nil
        circleOverlay = NMFCircleOverlay(location, radius: 1000)
        circleOverlay.fillColor = .pointBlue.withAlphaComponent(0.1)
        circleOverlay.outlineWidth = 1
        circleOverlay.outlineColor = .pointBlue
        circleOverlay.mapView = naverMapView
    }
    /**
     * @ 지도에 마커 추가
     * coder : sanghyeon
     */
    
    func addMarker(markers: [NMGLatLng]) {
        if markers.count <= 0 {
            print("addMarker called(), no data")
            return
        }
        naverMapMarker.mapView = nil
        for markerRow in markers {
            naverMapMarker = NMFMarker(position: markerRow)
            naverMapMarker.isHideCollidedMarkers = true
            naverMapMarker.mapView = naverMapView
        }
    }
    //MARK: Camera
    func mapView(_ mapView: NMFMapView, cameraIsChangingByReason reason: Int) {
        //let camPosition = naverMapView.cameraPosition
        //dump(camPosition)
        
    }
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
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            print("GPS 권한 설정됨")
            self.locationManager.startUpdatingLocation()
        case .restricted, .notDetermined:
            print("GPS 권한 설정되지 않음")
            getLocationUsagePermission()
        case .denied:
            print("GPS 권한 요청 거부됨")
            getLocationUsagePermission()
        default:
            print("GPS: Default")
        }
    }
    /**
     * @ 위치권한 요청
     * coder : sanghyeon
     */
    func getLocationUsagePermission() {
        self.locationManager.requestWhenInUseAuthorization()
    }
    /**
     * @ 재검색 관련 UI 토글
     * coder : sanghyeon
     */
    func showResearchElement(hide: Bool) {
        if hide {
            overlayCenterPick.isHidden = true
            researchButton.isHidden = true
        } else {
            self.overlayCenterPick.isHidden = false
            self.researchButton.isHidden = false
        }
    }
    /**
     * @ 상세뷰 오버 뷰
     * coder : sanghyeon
     */
    func showDetailOverView(hide: Bool) {
        guard let tabBar = self.tabBarController as? TabBarViewController else { return }
        if hide {
            detailOverView.removeFromSuperview()
            detailOverView.snp.removeConstraints()
            locationButton.snp.remakeConstraints {
                $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-40)
                $0.trailing.equalTo(view.safeAreaLayoutGuide).offset(-20)
                $0.width.height.equalTo(40)
            }
            tabBar.showTabBar(hide: false)
        } else {
            /* 나중에 함수화 */
            view.addSubview(detailOverView)
            detailOverView.snp.makeConstraints {
                $0.leading.trailing.bottom.equalToSuperview()
                $0.height.equalTo(300)
            }
            detailOverView.layer.applySketchShadow(color: .black, alpha: 0.12, x: 0, y: 0, blur: 14, spread: 0)
            locationButton.snp.remakeConstraints {
                $0.bottom.equalTo(detailOverView.snp.top).offset(-20)
                $0.trailing.equalTo(view.safeAreaLayoutGuide).offset(-20)
                $0.width.height.equalTo(40)
            }
            tabBar.showTabBar(hide: true)
        }
    }
}
//MARK: - CollectionView
extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return storeLists.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StoreTabCollectionViewCell.cellId, for: indexPath) as! StoreTabCollectionViewCell
        if let icon = UIImage(systemName: storeLists[indexPath.row].image) {
            cell.icon = icon
        }
        cell.itemText.text = storeLists[indexPath.row].title
        cell.storeId = storeLists[indexPath.row].id
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let labelSize = CommonUtils.getTextSizeWidth(text: storeLists[indexPath.row].title)

        
        return CGSize(width: labelSize.width + 35, height: 28)
    }
}
