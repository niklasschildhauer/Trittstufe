//
//  CarStepStatus.swift
//  Trittstufe
//
//  Created by Niklas Schildhauer on 28.05.22.
//

import Foundation

/// Assigns a current position to each CarStepIdentification, which can be either open, close or unkwon. At the beginning the status is unknown until a status update is sent by the step.
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
            case .open: return NSLocalizedString("Position_close", comment: "")
            case .close: return NSLocalizedString("Position_open", comment: "")
            }
        }
    }
    
    let step: CarStepIdentification
    var position: Position = .unknown
}
