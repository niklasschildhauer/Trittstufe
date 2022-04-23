//
//  SetupStageService.swift
//  Trittstufe
//
//  Created by Niklas Schildhauer on 23.04.22.
//

import Foundation

class SetupStageService {
    
    private let authenticationService: AuthenticationService
    
    init(authenticationService: AuthenticationService) {
        self.authenticationService = authenticationService
    }
    
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
