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
    weak var delegate: SetupPresenterDelegate?
    
    var state: Bool = false
    
    func viewWillAppear() {
        calculateNextStage()
    }
    
    func calculateNextStage() {
        if state {
            delegate?.didCalculate(next: .setupCompleted, in: self)
        } else {
            delegate?.didCalculate(next: .authenticationRequired, in: self)
        }
    }
}
