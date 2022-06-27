//
//  SetupStageService.swift
//  Trittstufe
//
//  Created by Niklas Schildhauer on 23.04.22.
//

import Foundation

/// SetupStageService
/// Calculates the next stage of the setup screen. It checks if the configuration is set and the user is authenticated.
class SetupStageService {
    private let authenticationService: AuthenticationService
    
    init(authenticationService: AuthenticationService) {
        self.authenticationService = authenticationService
    }
    
    /// Calculates the next setup stage
    func calculateNextStage() -> SetupStage {
        guard DummyBackendData.loadFromUserDefaults() != nil else {
            return .configurationMissing
        }
        
        guard let clientConfiguration = authenticationService.clientConfiguration else {
            return .authenticationRequired
        }
        
        return .setupCompleted(clientConfiguration: clientConfiguration)
    }
}
