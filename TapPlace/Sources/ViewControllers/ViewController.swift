//
//  ViewController.swift
//  TapPlace
//
//  Created by 박상현 on 2022/08/03.
//

import UIKit
import NMapsMap
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let mapView = NMFMapView(frame: view.frame)
        view.addSubview(mapView)
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        
        
        if CLLocationManager.locationServicesEnabled() {
            print("위치 서비스 On 상태")
            locationManager.startUpdatingLocation()
            
            let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: locationManager.location!.coordinate.latitude, lng: locationManager.location!.coordinate.longitude))
            cameraUpdate.animation = .easeIn
            mapView.moveCamera(cameraUpdate)
            
            let marker = NMFMarker()
            marker.position = NMGLatLng(lat: locationManager.location!.coordinate.latitude, lng: locationManager.location!.coordinate.longitude)
            marker.mapView = mapView
            
        } else {
            print("위치 서비스 Off 상태")
        }
    }
    
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        if let location = locations.last {
//            locationManager.stopUpdatingLocation()
//            let lat = location.coordinate.latitude
//            let lon = location.coordinate.longitude
//        }
//    }
//
//    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//        print(error)
//    }
}
