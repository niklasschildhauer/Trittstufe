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
    }
    
    let side: CarStepIdentification.Side
    var position: Position = .unknown
}
