//
//  SetupPresenter.swift
//  Trittstufe
//
//  Created by Niklas Schildhauer on 10.04.22.
//

import Foundation

protocol SetupView: AnyObject {
    var presenter: CalculateSetupStagePresenter! { get set }
}

protocol SetupPresenterDelegate: AnyObject {
    func didCalculate(next state: SetupStage, in presenter: CalculateSetupStagePresenter)
}

class CalculateSetupStagePresenter: Presenter {
    weak var view: SetupView?
    var delegate: SetupPresenterDelegate?
    
    private let authenticationService: AuthenticationService
    private let locationService: LocationService
    
    init(authenticationService: AuthenticationService, locationService: LocationService) {
        self.authenticationService = authenticationService
        self.locationService = locationService
    }
    
    func viewWillAppear() {
        calculateNextStage()
    }
    
    func calculateNextStage() {
        guard DummyBackendData.loadFromUserDefaults() != nil else {
            delegate?.didCalculate(next: .configurationMissing, in: self)
            return
        }
        
        guard locationService.permissionStatus() == .granted else {
            delegate?.didCalculate(next: .locationPermissionRequired, in: self)
            return
        }
        
        guard let clientConfiguration = authenticationService.clientConfiguration else {
            delegate?.didCalculate(next: .authenticationRequired, in: self)
            return
        }
        
        delegate?.didCalculate(next: .setupCompleted(clientConfiguration: clientConfiguration), in: self)
    }
}
