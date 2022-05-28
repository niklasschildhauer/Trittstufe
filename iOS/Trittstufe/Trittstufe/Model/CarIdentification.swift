//
//  CarIdentification.swift
//  Trittstufe
//
//  Created by Niklas Schildhauer on 26.05.22.
//

import Foundation
import UIKit

struct CarIdentification {
    let ipAdress: String
    let portNumber: UInt16
    let publicKey: String
    let model: String
    let steps: [CarStepIdentification]
    
    var image: UIImage {
        UIImage(named:"car-image")!
    }
}

struct CarStepIdentification: Codable {
    enum Side: String, Codable {
        case left
        case right
        case unknown
    }
    
    let uid: String // = UUID(uuidString: "05c13100-102b-42cf-babb-ace7dd99c4e3")!
    let side: Side
}
