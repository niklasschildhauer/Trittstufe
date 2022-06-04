//
//  CarIdentification.swift
//  Trittstufe
//
//  Created by Niklas Schildhauer on 26.05.22.
//

import Foundation
import UIKit

struct CarIdentification {
    let id: String
    let ipAdress: String
    let portNumber: UInt16
    let publicKey: String
    let model: String
    let stepIdentifications: [CarStepIdentification]
    
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

//struct CarStepIdentification: Codable {
//    enum Side: String, Codable {
//        case left
//        case right
//        case unknown
//    }
//
//    let uid: String // = UUID(uuidString: "05c13100-102b-42cf-babb-ace7dd99c4e3")!
//    let side: Side
//}
