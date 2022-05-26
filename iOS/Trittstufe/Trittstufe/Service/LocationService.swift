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
    func didRangeCar(car: CarIdentification, with proximity: CLProximity, meters: Double)
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
    
    private var locatedBeaconsHistory: [CLBeacon?] = []
    
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
    
    struct ProximityCount {
        let id: UUID
        var proximityCount: [CLProximity:Int]
    }
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        if beacons.count > 0 {
            locatedBeaconsHistory.append(contentsOf: beacons)
        } else {
            locatedBeaconsHistory.append(nil)
        }
        
        if locatedBeaconsHistory.count % 2 == 1 {
            return
        }
        
        guard let car = clientConfiguration?.carIdentification else { return }
        
        let history = locatedBeaconsHistory.count > 4 ? Array(locatedBeaconsHistory.suffix(4)) : locatedBeaconsHistory
        
        let proximityCount = history.reduce( [CLProximity.far:0, CLProximity.immediate:0, CLProximity.near:0, CLProximity.unknown:0] , { partialResult, beacon in
            var partialResult = partialResult
            if let beacon = beacon {
                if beacon.uuid == car.beaconId {
                    if var currentValue = partialResult[beacon.proximity] {
                        currentValue += 1
                        partialResult.updateValue(currentValue, forKey: beacon.proximity)
                    }
                }
            } else {
                if var currentValue = partialResult[.unknown] {
                    currentValue += 1
                    partialResult.updateValue(currentValue, forKey: .unknown)
                }            }
            return partialResult
        })
        
        guard let averageProximityCount = proximityCount.max(by: { $0.value < $1.value }) else { return }
        let averageProximity = averageProximityCount.key
        let count = averageProximityCount.value
        
        let sumMeters = history.reduce(0.0) { partialResult, beacon in
            if let beacon = beacon,
               beacon.uuid == car.beaconId ,
               beacon.proximity == averageProximity {
                return partialResult + beacon.accuracy
            }
            return partialResult
        }
        let averageMeters = sumMeters / Double(count)
        
        delegate?.didRangeCar(car: car, with: averageProximity, meters: averageMeters)
    }
}

extension CarIdentification {
    func asBeaconRegion() -> CLBeaconRegion {
        return CLBeaconRegion(uuid: beaconId, identifier: model)
    }
}
