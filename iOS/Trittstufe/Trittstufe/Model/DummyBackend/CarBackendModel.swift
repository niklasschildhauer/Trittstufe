//
//  Car.swift
//  Trittstufe
//
//  Created by Niklas Schildhauer on 18.04.22.
//

import Foundation

struct CarBackend: Codable {
    let model: String
    let ipAdress: String
    let port: UInt16
    let publicKey: String
    let authorizedUsers: [AuthorizedUser]
    let steps: [CarStepIdentification]
    
    struct AuthorizedUser: Codable {
        let userToken: String
    }
}



