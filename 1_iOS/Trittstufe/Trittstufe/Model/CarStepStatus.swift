//
//  CarStepStatus.swift
//  Trittstufe
//
//  Created by Niklas Schildhauer on 28.05.22.
//

import Foundation

struct CarStepStatus: Codable, Equatable {
    enum Position: String, Codable {
        case open
        case close
        case unknown
        
        var imageName: String {
            switch self {
            case .close: return "close"
            case .unknown: return "unknown"
            case .open: return "open"
            }
        }
        
        var swipeText: String {
            switch self {
            case .unknown: return ""
            case .open: return "Rechte Stufe einfahren"
            case .close: return "Rechte Stufe ausfahren"
            }
        }
    }
    
    let step: CarStepIdentification
    var position: Position = .unknown
}
