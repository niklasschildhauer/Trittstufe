//
//  LocationService.swift
//  Trittstufe
//
//  Created by Niklas Schildhauer on 17.04.22.
//

import Foundation
import CoreLocation
import UIKit

protocol LocationServiceStatusDelegate {
    func didChangeStatus(in service: LocationService)
}

protocol LocationServiceDelegate {
    func didFail(with error: String, in service: LocationService)
    func didRangeBeacons(beacons: [CLBeacon], in region: CLBeaconRegion)
}

class LocationService: NSObject {
    
    private let locationManager = CLLocationManager()
        
    enum LocationPermission {
        case granted
        case denied
        case notDetermined
    }
    
    struct Beacon {
        let id: UUID
        var proximity: CLProximity
    }
    
    var statusDelegate: LocationServiceStatusDelegate?
    var delegate: LocationServiceDelegate?
    
    var clientConfiguration: ClientConfiguration?
    
    private var locatedBeaconsHistory: [[CLBeacon]] = []
        
    override init() {
        super.init()
        
        locationManager.delegate = self
    }
    
    func startMonitoring() {
        guard let clientConfiguration = clientConfiguration else {
            return
        }

        let car = clientConfiguration.carIdentification
        let beaconRegion = car.asBeaconRegion()
        locationManager.startMonitoring(for: beaconRegion)
        locationManager.startRangingBeacons(satisfying: .init(uuid: car.beaconId))
    }
    
    func stopMonitoring() {
        guard let clientConfiguration = clientConfiguration else {
            return
        }
        
        let car = clientConfiguration.carIdentification
        let beaconRegion = car.asBeaconRegion()
        locationManager.stopMonitoring(for: beaconRegion)
        locationManager.stopRangingBeacons(satisfying: .init(uuid: car.beaconId))

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

extension LocationService: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        statusDelegate?.didChangeStatus(in: self)
    }
    
    func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
        delegate?.didFail(with: "Failed monitoring region: \(error.localizedDescription)", in: self)
    }
      
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        delegate?.didFail(with:"Location manager failed: \(error.localizedDescription)", in: self)
    }
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        locatedBeaconsHistory.append(beacons)
        
        guard beacons.count > 10 else { return }
        
        let history = locatedBeaconsHistory
        
        history.reduce([]) { partialResult, beacons in
            if partialResult.
        }
        
        delegate?.didRangeBeacons(beacons: beacons, in: region)
    }
}

extension ClientConfiguration.CarIdentification {
    func asBeaconRegion() -> CLBeaconRegion {
      return CLBeaconRegion(uuid: beaconId, identifier: model)
    }
}
