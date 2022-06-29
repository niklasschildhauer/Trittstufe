//
//  ClientConfiguration.swift
//  Trittstufe
//
//  Created by Niklas Schildhauer on 14.04.22.
//

import Foundation

/// The response of the local backend when the user logs in. Contains the user token for identification and the booked car identification.
struct ClientConfiguration {
    let userToken: String
    let carIdentification: CarIdentification
}
