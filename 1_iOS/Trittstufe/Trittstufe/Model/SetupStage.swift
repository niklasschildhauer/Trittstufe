//
//  SetupStage.swift
//  Trittstufe
//
//  Created by Niklas Schildhauer on 10.04.22.
//

import Foundation

/// Configuration stages that must be successfully passed through before the application can be used.
enum SetupStage {
    case configurationMissing
    case authenticationRequired
    case setupCompleted(clientConfiguration: ClientConfiguration)
}
