//
//  CLLocation+Extension.swift
//  TapPlace
//
//  Created by 박상현 on 2022/09/04.
//

import Foundation
import CoreLocation

extension CLLocationCoordinate2D {
    func distance(from: CLLocationCoordinate2D) -> CLLocationDistance {
        let from = CLLocation(latitude: from.latitude, longitude: from.longitude)
        let to = CLLocation(latitude: self.latitude, longitude: self.longitude)
        return from.distance(from: to) / 1000
    }
}
