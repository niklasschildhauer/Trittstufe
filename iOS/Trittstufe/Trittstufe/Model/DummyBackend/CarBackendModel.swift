//
//  Car.swift
//  Trittstufe
//
//  Created by Niklas Schildhauer on 18.04.22.
//

import Foundation

struct CarBackend: Codable {
    let model: String
    var beaconId: UUID = UUID(uuidString: "05c13100-102b-42cf-babb-ace7dd99c4e3")!
    let vin: String
    let ipAdress: String
    let port: UInt16
    let publicKey: String
    let authorizedUsers: [AuthorizedUser]
    
    struct AuthorizedUser: Codable {
        let userToken: String
        let dueDate: String
    }
}



