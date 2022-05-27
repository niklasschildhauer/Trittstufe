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
    let steps: [CarStepIdentification]
}

struct CarStepIdentification: Codable {
    enum Side: String, Codable {
        case left
        case right
    }
    
    let beaconId: String // = UUID(uuidString: "05c13100-102b-42cf-babb-ace7dd99c4e3")!
    let nfcTokenId: String
    let side: Side
}
