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

class MainViewController: UIViewController {
    
    var listButton: MapButton = MapButton() {
        willSet {
            listButton = newValue
        }
    }
    
    var locationButton: MapButton = MapButton() {
        willSet {
            locationButton = newValue
        }
    }
    
    var naverMapView: NMFMapView = NMFMapView() {
        willSet {
            naverMapView = newValue
        }
    }
    
    var naverMapMarker: NMFMarker = NMFMarker() {
        willSet {
            naverMapMarker = newValue
        }
    }
    
    private let locationManager = CLLocationManager()
    var circleOverlay: NMFCircleOverlay = NMFCircleOverlay() {
        willSet {
            circleOverlay = newValue
        }
    }
    
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


    let sampleStores = ["카페/디저트", "음식점", "편의점", "마트", "주유소", "기타1", "기타2"]
    
    let collectionView: UICollectionView = {
        let collectionViewLayout = AlignedCollectionViewFlowLayout()
        collectionViewLayout.scrollDirection = .horizontal
        collectionViewLayout.minimumInteritemSpacing = 10
        collectionViewLayout.minimumLineSpacing = 10
        collectionViewLayout.horizontalAlignment = .left
        //collectionViewLayout.headerReferenceSize = .init(width: 100, height: 40)
        let collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), collectionViewLayout: collectionViewLayout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupNaverMap()
        
    }
    
    
}
//MARK: - Layout
extension MainViewController: MapButtonProtocol {
    @objc func didTapMapButton(_ sender: MapButton) {
        print("맵버튼 터치")
        if sender == listButton.button {
            print("리스트 버튼 클릭")
        } else if sender == locationButton.button {
            getUserCurrentLocation()
            guard let location = currentLocation else { return }
            moveCamera(location: location)
            showInMapViewTracking()
        }
    } // Function: 맵뷰버튼 클릭 이벤트    
    /**
     * @ 검색창 클릭시 액션
     * coder : sanghyeon
     */
    @objc func didTapSearchButton() {
        let vc = SearchingViewController()
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
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
            searchButton.titleLabel?.font = .systemFont(ofSize: CommonUtils().resizeFontSize(size: 16), weight: .regular)
            searchButton.contentHorizontalAlignment = .left
            return searchButton
        }()
        listButton = MapButton()
        locationButton = MapButton()
        
        //MARK: ViewPropertyManual
        listButton.iconName = "list.bullet"
        listButton.layer.applySketchShadow(color: .black, alpha: 0.12, x: 0, y: 1, blur: 8, spread: 0)
        locationButton.iconName = "location"
        locationButton.layer.applySketchShadow(color: .black, alpha: 0.12, x: 0, y: 1, blur: 8, spread: 0)
        
        //MARK: AddSubView
        view.addSubview(searchBar)
        searchBar.addSubview(searchIcon)
        searchBar.addSubview(searchButton)
        view.addSubview(collectionView)
        view.addSubview(listButton)
        view.addSubview(locationButton)
        
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
            $0.leading.equalTo(safeArea).offset(20)
            $0.width.height.equalTo(40)
        }
        locationButton.snp.makeConstraints {
            $0.bottom.equalTo(safeArea).offset(-40)
            $0.trailing.equalTo(safeArea).offset(-20)
            $0.width.height.equalTo(40)
        }

        
        //MARK: ViewAddTarget
        searchButton.addTarget(self, action: #selector(didTapSearchButton), for: .touchUpInside)
        //listButton.button.addTarget(self, action: #selector(testTap(_:)), for: .touchUpInside)
        //locationButton.button.addTarget(self, action: #selector(didTapMapButton), for: .touchUpInside)
//
        
        //MARK: Delegate
        collectionView.delegate = self
        collectionView.dataSource = self
        listButton.delegate = self
        locationButton.delegate = self
        
        collectionView.register(StoreTabCollectionViewCell.self, forCellWithReuseIdentifier: "storeTabItem")
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    } // Function: 레이아웃 설정
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    

}
//MARK: - NaverMap
extension MainViewController: CLLocationManagerDelegate {
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
        showInMapViewTracking()
        
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
    func showInMapViewTracking() {
        getUserCurrentLocation()
        guard let location = currentLocation else { return }
        
        /// 트래킹
        let locationOverlay = naverMapView.locationOverlay
        locationOverlay.location = location
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
    /**
     * @ 위치권한 설정
     * coder : sanghyeon
     */
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            print("GPS 권한 설정됨")
            self.locationManager.startUpdatingLocation() // 중요!
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
}
//MARK: - CollectionView
extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sampleStores.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "storeTabItem", for: indexPath) as! StoreTabCollectionViewCell
        cell.itemText.text = sampleStores[indexPath.row]
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let labelSize = CommonUtils().getTextSizeWidth(text: sampleStores[indexPath.row])
        return CGSize(width: labelSize.width + 20, height: 28)
    }
}
