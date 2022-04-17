//
//  LocationService.swift
//  Trittstufe
//
//  Created by Niklas Schildhauer on 17.04.22.
//

import Foundation
import CoreLocation

class LocationService {
    
    private let locationManager = CLLocationManager()
    
    enum LocationPermission {
        case granted
        case denied
        case notDetermined
    }
    
    var delegate: CLLocationManagerDelegate? {
        didSet {
            guard let delegate = delegate else {
                return
            }
            locationManager.delegate = delegate
        }
    }
    
    func requestAuthorization() {
        locationManager.requestAlwaysAuthorization()
    }
    
    
    func permissionStatus() -> LocationPermission {
        if CLLocationManager.locationServicesEnabled() {
            switch locationManager.authorizationStatus {
            case .notDetermined:
                return .notDetermined
            case .restricted, .denied:
                return .denied
            case .authorizedAlways, .authorizedWhenInUse:
                return .granted
            @unknown default:
                break
            }
        }
        return .notDetermined
    }
    
}
