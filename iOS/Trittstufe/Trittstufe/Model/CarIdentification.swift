//
//  CarIdentification.swift
//  Trittstufe
//
//  Created by Niklas Schildhauer on 26.05.22.
//

import Foundation

struct CarIdentification {
    let ipAdress: String
    let portNumber: UInt16
    let publicKey: String
    let model: String
    let vin: String
    let beaconId: UUID
}
