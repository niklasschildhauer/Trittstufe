//
//  ClientConfiguration.swift
//  Trittstufe
//
//  Created by Niklas Schildhauer on 14.04.22.
//

import Foundation

struct ClientConfiguration {
    let userToken: String
    let carIdentification: CarIdentification
    
    struct CarIdentification {
        let ipAdress: String
        let portNumber: UInt16
        let publicKey: String
        let model: String
        let vin: String
        let beaconId: UUID
    }
}
