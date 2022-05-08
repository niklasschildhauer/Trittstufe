//
//  Car.swift
//  Trittstufe
//
//  Created by Niklas Schildhauer on 18.04.22.
//

import Foundation

struct Car: Codable {
    let model: String
    var beaconId: UUID = UUID(uuidString: "e339d8b2-7b73-40fd-9c58-44e6b3d1c608")!
    let vin: String
    let ipAdress: String
    let port: UInt16
    let publicKey: String
    let authorizedUsers: [AuthorizedUser]
    
    struct AuthorizedUser: Codable {
        let userIdentification: String
        let dueDate: String
    }
}



