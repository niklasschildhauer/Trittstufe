//
//  ViewController.swift
//  BeaconDevice
//
//  Created by Niklas Schildhauer on 27.05.22.
//

import UIKit
import CoreLocation


class ViewController: UIViewController {
    
    private let locationManager = CLLocationManager()
    let beaconUUID = UUID(uuidString: "05c13100-102b-42cf-babb-ace7dd99c4e3")!
    var region: CLBeaconRegion?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let bundleURL = Bundle.main.bundleIdentifier!
        
        // Defines the beacon identity characteristics the device broadcasts.
        let constraint = CLBeaconIdentityConstraint(uuid: beaconUUID, major: 1, minor: 100)
        region = CLBeaconRegion(beaconIdentityConstraint: constraint, identifier: bundleURL)
        
        let peripheralData = region!.peripheralData(withMeasuredPower: nil) as? [String: Any]
        
        // Start broadcasting the beacon identity characteristics.
        locationManager.startAdvertising(peripheralData)
    }
    
    
}

