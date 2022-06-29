//
//  CarIdentification.swift
//  Trittstufe
//
//  Created by Niklas Schildhauer on 26.05.22.
//

import Foundation
import UIKit

/// Contains the information important for the app to identify the booked car. Includes IP address and port number of the broker, as well as the car id and the step identifications.
struct CarIdentification {
    let id: String
    let ipAdress: String
    let portNumber: UInt16
    let publicKey: String
    let model: String
    /// A car can have any number of steps, which can be controlled individually. The app is currently designed so that 2 steps can be controlled per car.
    let stepIdentifications: [CarStepIdentification]
    
    /// The UUID is used to identify a car. The UUID is stored in the NFC tags and is broadcast by the car's iBeacon.
    var uuid: UUID? {
        UUID(uuidString: id)
    }

    var image: UIImage {
        UIImage(named:"car-image")!
    }
}

enum CarStepIdentification: Int, Codable {
    case right = 1
    case left = 2
    case unknown = 0
    
    var name: String {
        switch self {
        case .right:
            return "right"
        case .left:
            return "left"
        case .unknown:
            return "?"
        }
    }
}
