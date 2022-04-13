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
    
    private let userService: UserService
    private let configurationService: ConfigurationService
    
    init(userService: UserService, configurationService: ConfigurationService) {
        self.userService = userService
        self.configurationService = configurationService
    }
    
    func viewWillAppear() {
        calculateNextStage()
    }
    
    func calculateNextStage() {
        guard configurationService.isConfigured else {
            delegate?.didCalculate(next: .configurationMissing, in: self)
            return
        }
        
        guard userService.userLoggedIn else {
            delegate?.didCalculate(next: .authenticationRequired, in: self)
            return
        }
        
        delegate?.didCalculate(next: .setupCompleted, in: self)
    }
}
