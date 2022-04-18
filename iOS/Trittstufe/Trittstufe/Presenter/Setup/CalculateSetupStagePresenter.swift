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
    
    init(authenticationService: AuthenticationService) {
        self.authenticationService = authenticationService
    }
    
    func viewWillAppear() {
        calculateNextStage()
    }
    
    func viewDidAppear() {
        calculateNextStage()
    }
    
    func calculateNextStage() {
        guard DummyBackendData.loadFromUserDefaults() != nil else {
            delegate?.didCalculate(next: .configurationMissing, in: self)
            return
        }
        
        guard let clientConfiguration = authenticationService.clientConfiguration else {
            delegate?.didCalculate(next: .authenticationRequired, in: self)
            return
        }
        
        delegate?.didCalculate(next: .setupCompleted(clientConfiguration: clientConfiguration), in: self)
    }
}
