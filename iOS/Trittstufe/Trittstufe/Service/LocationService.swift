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
    
    private var beaconConstraints = [CLBeaconIdentityConstraint: [CLBeacon]]()
    private var beacons = [CLProximity: [CLBeacon]]()
    
    enum LocationPermission {
        case granted
        case denied
        case notDetermined
    }
    
//    struct Beacon {
//        let id: UUID
//        var proximity: CLProximity
//    }
    
    var statusDelegate: LocationServiceStatusDelegate?
    var delegate: LocationServiceDelegate?
    
    var clientConfiguration: ClientConfiguration?
        
    override init() {
        super.init()
        
        locationManager.delegate = self
    }
    
    func startMonitoring() {
        guard let clientConfiguration = clientConfiguration else {
            return
        }
        
        clientConfiguration.carIdentification.steps.forEach { steps in
         
            // Create a new constraint and add it to the dictionary.
            let constraint = CLBeaconIdentityConstraint(uuid: UUID(uuidString: steps.beaconId)!)
            self.beaconConstraints[constraint] = []
            
            /*
            By monitoring for the beacon before ranging, the app is more
            energy efficient if the beacon is not immediately observable.
            */
            let beaconRegion = CLBeaconRegion(beaconIdentityConstraint: constraint, identifier: steps.beaconId)
            self.locationManager.startMonitoring(for: beaconRegion)
        }
        
//        let car = clientConfiguration.carIdentification
//        let beaconRegion = car.asBeaconRegion()
//        locationManager.startMonitoring(for: beaconRegion)
//        locationManager.startRangingBeacons(satisfying: .init(uuid: car.beaconId))
    }
    
    func stopMonitoring() {
        // Stop monitoring when the view disappears.
        for region in locationManager.monitoredRegions {
            locationManager.stopMonitoring(for: region)
        }
        
        // Stop ranging when the view disappears.
        for constraint in beaconConstraints.keys {
            locationManager.stopRangingBeacons(satisfying: constraint)
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
    
    func locationManager(_ manager: CLLocationManager, didDetermineState state: CLRegionState, for region: CLRegion) {
        let beaconRegion = region as? CLBeaconRegion
        if state == .inside {
            // Start ranging when inside a region.
            manager.startRangingBeacons(satisfying: beaconRegion!.beaconIdentityConstraint)
        } else {
            // Stop ranging when not inside a region.
            manager.stopRangingBeacons(satisfying: beaconRegion!.beaconIdentityConstraint)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didRange beacons: [CLBeacon], satisfying beaconConstraint: CLBeaconIdentityConstraint) {
        /*
         Beacons are categorized by proximity. A beacon can satisfy
         multiple constraints and can be displayed multiple times.
         */
        beaconConstraints[beaconConstraint] = beacons
        
        self.beacons.removeAll()
        
        var allBeacons = [CLBeacon]()
        
        for regionResult in beaconConstraints.values {
            allBeacons.append(contentsOf: regionResult)
        }
        
        for range in [CLProximity.unknown, .immediate, .near, .far] {
            let proximityBeacons = allBeacons.filter { $0.proximity == range }
            if !proximityBeacons.isEmpty {
                self.beacons[range] = proximityBeacons
            }
        }
        
//        allBeacons.filter { $0.uuid == car.steps.contains(where: {      <#code#>
//        }) }
        
        guard let clientConfiguration = clientConfiguration else {
            return
        }
        
        delegate?.didRangeCar(car: clientConfiguration.carIdentification, with: .immediate, meters: 10)

//        if beacons.count > 0 {
//            locatedBeaconsHistory.append(contentsOf: beacons)
//        } else {
//            locatedBeaconsHistory.append(nil)
//        }
//
//        if locatedBeaconsHistory.count % 2 == 1 {
//            return
//        }
//
//        guard let car = clientConfiguration?.carIdentification else { return }
//
//        let history = locatedBeaconsHistory.count > 4 ? Array(locatedBeaconsHistory.suffix(4)) : locatedBeaconsHistory
//
//        let proximityCount = history.reduce( [CLProximity.far:0, CLProximity.immediate:0, CLProximity.near:0, CLProximity.unknown:0] , { partialResult, beacon in
//            var partialResult = partialResult
//            if let beacon = beacon {
//                if beacon.uuid == car.beaconId {
//                    if var currentValue = partialResult[beacon.proximity] {
//                        currentValue += 1
//                        partialResult.updateValue(currentValue, forKey: beacon.proximity)
//                    }
//                }
//            } else {
//                if var currentValue = partialResult[.unknown] {
//                    currentValue += 1
//                    partialResult.updateValue(currentValue, forKey: .unknown)
//                }            }
//            return partialResult
//        })
//
//        guard let averageProximityCount = proximityCount.max(by: { $0.value < $1.value }) else { return }
//        let averageProximity = averageProximityCount.key
//        let count = averageProximityCount.value
//
//        let sumMeters = history.reduce(0.0) { partialResult, beacon in
//            if let beacon = beacon,
//               beacon.uuid == car.beaconId ,
//               beacon.proximity == averageProximity {
//                return partialResult + beacon.accuracy
//            }
//            return partialResult
//        }
//        let averageMeters = sumMeters / Double(count)
//
//        delegate?.didRangeCar(car: car, with: averageProximity, meters: averageMeters)
    }
}

//extension CarIdentification {
//    func asBeaconRegion() -> CLBeaconRegion {
//        return CLBeaconRegion(uuid: beaconId, identifier: model)
//    }
//}
