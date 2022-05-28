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
    func didRangeNothing(in service: LocationService)
    func didRangeCar(car: CarIdentification, side: CarStepIdentification.Side, with proximity: CLProximity, meters: Double, in service: LocationService)
}

class LocationService: NSObject {
    
    private let locationManager = CLLocationManager()
    
    private var beaconConstraints = [CLBeaconIdentityConstraint: [CLBeacon]]()
    private var beacons = [CLProximity: [CLBeacon]]()
    private var nothingRangedCount = 0
    
    var statusDelegate: LocationServiceStatusDelegate?
    var delegate: LocationServiceDelegate?
    
    var clientConfiguration: ClientConfiguration?
    
    enum LocationPermission {
        case granted
        case denied
        case notDetermined
    }
    
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
            let constraint = CLBeaconIdentityConstraint(uuid: UUID(uuidString: steps.uid)!)
            self.beaconConstraints[constraint] = []
            
            /*
             By monitoring for the beacon before ranging, the app is more
             energy efficient if the beacon is not immediately observable.
             */
            let beaconRegion = CLBeaconRegion(beaconIdentityConstraint: constraint, identifier: steps.uid)
            self.locationManager.startMonitoring(for: beaconRegion)
        }
        
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
        
        if let closestBeacon = getClosestBeacon(beacons: allBeacons),
           let car = clientConfiguration?.carIdentification,
           let side = getCarSideFor(beacon: closestBeacon, car: car) {
            nothingRangedCount = 0
            delegate?.didRangeCar(car: car, side: side, with: closestBeacon.proximity, meters: closestBeacon.accuracy, in: self)
        } else {
            nothingRangedCount = nothingRangedCount + 1
            if nothingRangedCount > 6 {
                delegate?.didRangeNothing(in: self)
            }
        }
    }
    
    private func getClosestBeacon(beacons: [CLBeacon]) -> CLBeacon? {
        beacons.sorted { $0.accuracy > $1.accuracy }.first
    }
    
    private func getCarSideFor(beacon: CLBeacon, car: CarIdentification) -> CarStepIdentification.Side? {
        let beaconId = beacon.uuid
        for step in car.steps {
            if let stepUUID = UUID(uuidString: step.uid),
               stepUUID == beaconId{
                return step.side
            }
        }
        return nil
    }
}
