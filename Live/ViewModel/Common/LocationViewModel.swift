//
//  LocationViewModel.swift
//  Live
//
//  Created by lieon on 2017/7/10.
//  Copyright © 2017年 ChengDuHuanLeHui. All rights reserved.
//

import Foundation

private let shareInstance = LocationViewModel()
class LocationViewModel: NSObject {
    var latitude: CLLocationDegrees = 0.0
    var longitude: CLLocationDegrees = 0.0
    var cityName: String = ""
    static let share: LocationViewModel = shareInstance
    /// 定位对象
    fileprivate lazy var llocationManager: CLLocationManager = CLLocationManager()
    
     func startLocate() {
        if CLLocationManager.locationServicesEnabled() {
             LocationViewModel.share.llocationManager.delegate =  LocationViewModel.share
             LocationViewModel.share.llocationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
             LocationViewModel.share.llocationManager.requestWhenInUseAuthorization()
             LocationViewModel.share.llocationManager.startUpdatingLocation()
        }
    }
}

extension LocationViewModel: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let currentLocation: CLLocation = locations.last {
            let location: CLLocation = locations[0]
            let coordinate2D: CLLocationCoordinate2D = location.coordinate
            let baidu: CLLocationCoordinate2D = Utils.bd09(fromGCJ02: coordinate2D)
            LocationViewModel.share.latitude = baidu.latitude
            LocationViewModel.share.longitude = baidu.longitude
            let geocoder: CLGeocoder = CLGeocoder()
            geocoder.reverseGeocodeLocation(currentLocation, completionHandler: { (arr, error) in
                guard let arr = arr else { return }
                if !arr.isEmpty {
                    if let placemark: CLPlacemark = arr.first {
                        var currentCity: String = ""
                        if let city: String = placemark.locality {
                            currentCity = city
                        } else {
                            guard let arrea =  placemark.administrativeArea else { return }
                            currentCity = arrea
                        }
//                        print("currentCity : \(currentCity)")
                        LocationViewModel.share.cityName = currentCity
                        if !LocationViewModel.share.cityName.isEmpty {
                             LocationViewModel.share.llocationManager.stopUpdatingLocation()
                        }
                    }
                }
            })
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//        print("error:\(error.localizedDescription)")
    }
}
